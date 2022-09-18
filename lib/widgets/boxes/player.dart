import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/player.dart';
import '../../widgets/boxes/amount_data.dart';

class PlayerBox extends StatefulWidget {
  // Opponents of this Player
  final List<Player> opponents;
  // Rotation of this widget within the Grid
  final int rotation;
  // Called when toggling commander/normal view

  final bool diceRollWinner;

  const PlayerBox({
    Key? key,
    required this.opponents,
    required this.rotation,
    required this.diceRollWinner,
  }) : super(key: key);

  @override
  _PlayerBox createState() => _PlayerBox();
}

class _PlayerBox extends State<PlayerBox> {
  String mode = "normal";

  Widget _getContent(Player player) {
    // Show the dice roll winner
    if (widget.diceRollWinner) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          "You Win the Dice Roll",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );
    }

    // Show the normal values (and toggling between types)
    return AmountDataBox(opponents: widget.opponents);
  }

  @override
  Widget build(BuildContext context) {
    var player = Provider.of<Player>(context, listen: false);

    return Expanded(
      child: RotatedBox(
        quarterTurns: widget.rotation,
        child: Container(
          margin: const EdgeInsets.all(4),
          color: player.getColor(context),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
            ) =>
                ScaleTransition(
              child: child,
              scale: animation,
            ),
            child: _getContent(player),
          ),
        ),
      ),
    );
  }
}
