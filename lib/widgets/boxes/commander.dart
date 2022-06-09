import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/player.dart';

class CommanderBox extends StatefulWidget {
  final Function onToggleCommanderView;

  const CommanderBox({
    Key? key,
    required this.onToggleCommanderView,
  }) : super(key: key);

  @override
  _CommanderBox createState() => _CommanderBox();
}

class _CommanderBox extends State<CommanderBox> {
  @override
  Widget build(BuildContext context) {
    var player = Provider.of<Player>(context, listen: false);
    return Container(
      color: player.color,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Please assign your Commander Damage"),
          Material(
            color: Colors.transparent,
            child: IconButton(
              iconSize: 22, //widget.size == TrackerSize.small ? 22 : 32,
              icon: const Icon(
                Icons.close,
                color: Colors.white70,
              ),
              onPressed: () {
                widget.onToggleCommanderView(player);
              },
            ),
          ),
        ],
      ),
    );
  }
}
