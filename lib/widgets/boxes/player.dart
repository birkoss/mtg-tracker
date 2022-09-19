import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/players.dart';
import '../../providers/player.dart';
import '../../widgets/boxes/amount_data.dart';
import '../../widgets/ui/toggles.dart';

class PlayerBox extends StatefulWidget {
  // Opponents of this Player
  final List<Player> opponents;
  // Rotation of this widget within the Grid
  final int rotation;

  const PlayerBox({
    Key? key,
    required this.opponents,
    required this.rotation,
  }) : super(key: key);

  @override
  _PlayerBox createState() => _PlayerBox();
}

class _PlayerBox extends State<PlayerBox> {
  bool _showSettings = false;

  List<Widget> _getContent(Player player) {
    List<Widget> widgets = [];

    // Show the normal values (and toggling between types)
    widgets.add(
      AmountDataBox(
        showSettings: () {
          setState(() {
            _showSettings = true;
          });
        },
        opponents: widget.opponents,
      ),
    );

    // Show the dice roll winner
    if (context.watch<Players>().diceRollWinner == player) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.all(6),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "You Win the Dice Roll",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: context.read<Player>().getColor(context),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (_showSettings) {
      // Has Partner ?
      // - Enable multiple commanders
      // Is Dead ?
      // - Show a Skull instead of the stats
      // - Opacity the opponent Commander Damage (disable click)
      widgets.add(
        Padding(
          padding: const EdgeInsets.all(6),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Settings",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(
                            "Has a partner",
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const SizedBox(height: 10),
                          Toggles(
                            defaultValue: player.data['totalCommanders']!,
                            values: const [
                              {"value": "1", "label": "No"},
                              {"value": "2", "label": "Yes"},
                            ],
                            onChanged: (int value) {
                              player.updateTotalCommanders(value);
                              context.read<Players>().hasChanged();
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(
                            "Is Dead!",
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const SizedBox(height: 10),
                          Toggles(
                            defaultValue: 1,
                            values: const [
                              {"value": "1", "label": "No"},
                              {"value": "2", "label": "Yes"},
                            ],
                            onChanged: (int value) {
                              setState(() {
                                //_selectedPlayersNumber = value;
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showSettings = false;
                    });
                  },
                  icon: const Icon(Icons.close),
                  label: const Text("Close"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return widgets;
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
            child: Stack(
              children: _getContent(player),
            ),
          ),
        ),
      ),
    );
  }
}
