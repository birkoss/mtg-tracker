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

enum PlayerBoxView {
  normal,
  commander,
}

class PlayerBox extends StatefulWidget {
  // Rotation of this widget within the Grid
  final int rotation;

  final PlayerBoxSize size;
  final PlayerBoxView view;
  final Function onToggleCommanderView;
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
                onChangeType: () {
                  print("CHANGE TYPE of " + player.id);
                },
              ),
      ),
    );
  }
}
