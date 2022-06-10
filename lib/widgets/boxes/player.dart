import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/player.dart';
import '../../widgets/boxes/amount_commander.dart';
import '../../widgets/boxes/amount_data.dart';
import '../../widgets/boxes/commander.dart';

class PlayerBox extends StatefulWidget {
  // Rotation of this widget within the Grid
  final int rotation;
  // Called when toggling commander/normal view
  final Function onToggleCommanderView;
  // The player currently in commander view
  final Player? selectedPlayer;

  final bool diceRollWinner;

  const PlayerBox({
    Key? key,
    required this.rotation,
    required this.onToggleCommanderView,
    required this.selectedPlayer,
    required this.diceRollWinner,
  }) : super(key: key);

  @override
  _PlayerBox createState() => _PlayerBox();
}

class _PlayerBox extends State<PlayerBox> {
  Widget _getContent(Player player) {
    // Show the dice roll winner
    if (widget.diceRollWinner) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: Flexible(
          child: Text(
            "You Win the Dice Roll",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    // Show the commander panel and commander values
    if (widget.selectedPlayer == player) {
      return CommanderBox(
        onToggleCommanderView: widget.onToggleCommanderView,
      );
    } else if (widget.selectedPlayer != null) {
      return AmountCommanderBox(selectedPlayer: widget.selectedPlayer!);
    }

    // Show the normal values (and toggling between types)
    return AmountDataBox(
      onToggleCommanderView: widget.onToggleCommanderView,
    );
  }

  @override
  Widget build(BuildContext context) {
    var player = Provider.of<Player>(context, listen: false);

    return Expanded(
      child: RotatedBox(
        quarterTurns: widget.rotation,
        child: Container(
          color: player.color,
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
