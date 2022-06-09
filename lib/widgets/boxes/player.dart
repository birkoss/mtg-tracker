import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/player.dart';

import '../../widgets/boxes/amount.dart';

enum PlayerBoxSize { small, medium, large }

enum PlayerBoxType { normal, poison, commander }

class PlayerBox extends StatefulWidget {
  final int rotation;
  final PlayerBoxSize size;
  final PlayerBoxType type;
  final Function onPressOptions;

  const PlayerBox({
    Key? key,
    required this.rotation,
    required this.size,
    required this.type,
    required this.onPressOptions,
  }) : super(key: key);

  @override
  _PlayerBox createState() => _PlayerBox();
}

class _PlayerBox extends State<PlayerBox> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    var player = Provider.of<Player>(context, listen: false);
    print(player.health);
    return Expanded(
      child: RotatedBox(
        quarterTurns: widget.rotation,
        child: AmountBox(
            boxType: widget.type,
            onSwitchCommander: widget.onPressOptions,
            onChangeType: () {
              print("CHANGE TYPE...");
            }),
      ),
    );
  }
}
