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

// What are we modifying in the Amount Box
enum PlayerBoxType {
  normal,
  commander,
  poison,
  energy,
  experience,
}

enum PlayerBoxView {
  normal,
  commander,
}

class PlayerBox extends StatefulWidget {
  // Rotation of this widget within the Grid
  final int rotation;

  final PlayerBoxSize size;
  final PlayerBoxType type;
  final PlayerBoxView view;
  final Function onToggleCommanderView;
  final bool isSelected;

  const PlayerBox({
    Key? key,
    required this.rotation,
    required this.size,
    required this.type,
    required this.view,
    required this.onToggleCommanderView,
    required this.isSelected,
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
        child: widget.isSelected
            ? CommanderBox(
                onToggleCommanderView: widget.onToggleCommanderView,
              )
            : AmountBox(
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
