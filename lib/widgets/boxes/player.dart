import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../providers/players.dart';
import '../../providers/player.dart';
import '../../providers/setting.dart';
import '../../widgets/boxes/amount_data.dart';
import '../../widgets/ui/toggles.dart';

class PlayerBox extends StatefulWidget {
  // Rotation of this widget within the Grid
  final int rotation;

  const PlayerBox({
    Key? key,
    required this.rotation,
  }) : super(key: key);

  @override
  _PlayerBox createState() => _PlayerBox();
}

class _PlayerBox extends State<PlayerBox> {
  bool _showSettings = false;

  List<Widget> _getContent(Player player) {
    bool isDarkTheme = context.watch<SettingNotifier>().isDarkTheme;

    List<Widget> widgets = [];

    if (player.isDead) {
      widgets.add(
        Container(
          padding: const EdgeInsets.all(6),
          width: double.infinity,
          height: double.infinity,
          color: context.read<Player>().getColor(isDarkTheme),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _showSettings = true;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: SvgPicture.asset(
                  "assets/icons/skull.svg",
                  fit: BoxFit.scaleDown,
                  color: Colors.white24,
                  semanticsLabel: 'Health',
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      // Show the normal values (and toggling between types)
      widgets.add(
        AmountDataBox(
          showSettings: () {
            setState(() {
              _showSettings = true;
            });
          },
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
                    color: context.read<Player>().getColor(isDarkTheme),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

    if (player.isDead) {
      widgets.add(
        Container(
          padding: const EdgeInsets.all(6),
          width: double.infinity,
          height: double.infinity,
          color: context.read<Player>().getColor(isDarkTheme),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _showSettings = true;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: SvgPicture.asset(
                  "assets/icons/skull.svg",
                  key: const ValueKey<String>("skull"),
                  fit: BoxFit.scaleDown,
                  color: Colors.white24,
                  semanticsLabel: 'Health',
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (_showSettings) {
      // Is Dead ?
      // - Opacity the opponent Commander Damage (disable click)
      widgets.add(
        Padding(
          padding: const EdgeInsets.all(6),
          child: Container(
            color: context.read<SettingNotifier>().isDarkTheme
                ? Colors.black
                : Colors.white,
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
                              // Must notify all players to refresh the UI
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
                            defaultValue: player.isDead ? 2 : 1,
                            values: const [
                              {"value": "1", "label": "No"},
                              {"value": "2", "label": "Yes"},
                            ],
                            onChanged: (int value) {
                              setState(() {
                                //_selectedPlayersNumber = value;
                                player.isDead = (value == 2);
                                // Must notify all players to refresh the UI
                                context.read<Players>().hasChanged();
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
          color: player.getColor(context.read<SettingNotifier>().isDarkTheme),
          alignment: Alignment.center,
          child: Stack(
            children: _getContent(player),
          ),
        ),
      ),
    );
  }
}
