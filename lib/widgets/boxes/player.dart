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

  const PlayerBox({
    Key? key,
    required this.rotation,
    required this.size,
    required this.view,
    required this.onToggleCommanderView,
    required this.selectedPlayer,
  }) : super(key: key);

  @override
  _PlayerBox createState() => _PlayerBox();
}

class _PlayerBox extends State<PlayerBox> {
  @override
  Widget build(BuildContext context) {
    var player = Provider.of<Player>(context, listen: false);
    return Expanded(
      child: RotatedBox(
        quarterTurns: widget.rotation,
        child: widget.selectedPlayer == player
            ? CommanderBox(
                onToggleCommanderView: widget.onToggleCommanderView,
              )
            : AmountBox(
                selectedPlayer: widget.selectedPlayer,
                boxView: widget.view,
                onSwitchCommander: widget.onToggleCommanderView,
              ),
      ),
    );
  }
}
