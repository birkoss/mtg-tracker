import 'package:flutter/material.dart';
import 'package:mtgtracker/widgets/boxes/empty.dart';
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
    print("CommanderBox.build()");
    var player = Provider.of<Player>(context, listen: false);
    return Container(
      color: player.color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text(
              "Please assign your Commander Damage",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: IconButton(
              iconSize: 22,
              icon: const Icon(
                Icons.close,
                color: Colors.white70,
              ),
              onPressed: () {
                widget.onToggleCommanderView(player);
              },
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
