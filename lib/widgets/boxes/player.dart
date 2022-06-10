import 'package:flutter/material.dart';
import 'package:mtgtracker/widgets/boxes/commander.dart';
import 'package:provider/provider.dart';

import '../../providers/player.dart';

import '../../widgets/boxes/amount.dart';

// What type of box should be visible
enum PlayerBoxView {
  normal,
  commander,
}

class PlayerBox extends StatefulWidget {
  // Rotation of this widget within the Grid
  final int rotation;
  // normal or commander view
  final PlayerBoxView view;
  // Called when toggling commander/normal view
  final Function onToggleCommanderView;
  // The player currently in commander view
  final Player? selectedPlayer;

  final bool diceRollWinner;

  const PlayerBox({
    Key? key,
    required this.rotation,
    required this.view,
    required this.onToggleCommanderView,
    required this.selectedPlayer,
    required this.diceRollWinner,
  }) : super(key: key);

  @override
  _PlayerBox createState() => _PlayerBox();
}

class _PlayerBox extends State<PlayerBox> {
  Widget _getContent(Player player) {
    if (widget.diceRollWinner) {
      return const Text(
        "You Win the Dice Roll",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      );
    }

    if (widget.selectedPlayer == player) {
      return CommanderBox(
        onToggleCommanderView: widget.onToggleCommanderView,
      );
    }

    return AmountBox(
      selectedPlayer: widget.selectedPlayer,
      boxView: widget.view,
      onSwitchCommander: widget.onToggleCommanderView,
    );
  }

  @override
  Widget build(BuildContext context) {
    var player = Provider.of<Player>(context, listen: false);

    print("PlayerBox.build() - Player ID:" + player.id);

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
