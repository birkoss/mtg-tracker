import 'package:flutter/material.dart';
import 'package:mtgtracker/widgets/boxes/commander.dart';
import 'package:provider/provider.dart';

import '../../providers/player.dart';

import '../../widgets/boxes/amount.dart';

enum PlayerBoxSize {
  small,
  medium,
  large,
}

// What type of box should be visible
enum PlayerBoxView {
  normal,
  commander,
}

class PlayerBox extends StatefulWidget {
  // Rotation of this widget within the Grid
  final int rotation;
  // Size of the box depending on the grid layout and players number
  final PlayerBoxSize size;
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
    required this.size,
    required this.view,
    required this.onToggleCommanderView,
    required this.selectedPlayer,
    required this.diceRollWinner,
  }) : super(key: key);

  @override
  _PlayerBox createState() => _PlayerBox();
}

class _PlayerBox extends State<PlayerBox> {
  @override
  Widget build(BuildContext context) {
    print("playerbox.build()");
    var player = Provider.of<Player>(context, listen: false);

    return Expanded(
      child: RotatedBox(
        quarterTurns: widget.rotation,
        child: Container(
          color: player.color,
          alignment: Alignment.center,
          child: widget.diceRollWinner
              ? const Text("You Win the Dice Roll",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ))
              : widget.selectedPlayer == player
                  ? CommanderBox(
                      onToggleCommanderView: widget.onToggleCommanderView,
                    )
                  : AmountBox(
                      selectedPlayer: widget.selectedPlayer,
                      boxView: widget.view,
                      onSwitchCommander: widget.onToggleCommanderView,
                    ),
        ),
      ),
    );
  }
}
