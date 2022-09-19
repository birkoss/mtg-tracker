import 'package:flutter/material.dart';
import 'package:mtgtracker/providers/setting.dart';
import 'package:mtgtracker/widgets/ui/toggles.dart';
import 'package:provider/provider.dart';

import '../../providers/player.dart';
import '../../widgets/boxes/amount_data.dart';

class PlayerBox extends StatefulWidget {
  // Opponents of this Player
  final List<Player> opponents;
  // Rotation of this widget within the Grid
  final int rotation;
  // Called when toggling commander/normal view

  final bool diceRollWinner;

  const PlayerBox({
    Key? key,
    required this.opponents,
    required this.rotation,
    required this.diceRollWinner,
  }) : super(key: key);

  @override
  _PlayerBox createState() => _PlayerBox();
}

class _PlayerBox extends State<PlayerBox> {
  bool _showSettings = false;

  Widget _getContent(Player player) {
    // Show the dice roll winner
    if (widget.diceRollWinner) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          "You Win the Dice Roll",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
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
      return Padding(
        padding: const EdgeInsets.all(8),
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
                            setState(() {
                              player.data['totalCommanders'] = value;
                              SettingNotifier setting =
                                  Provider.of<SettingNotifier>(context,
                                      listen: false);
                              // @TODO: Replace this ugly Hack to force a refresh!
                              setting.notifyListeners();
                            });
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
      );
    }

    // Show the normal values (and toggling between types)
    return AmountDataBox(
        showSettings: () {
          setState(() {
            _showSettings = true;
          });
        },
        opponents: widget.opponents);
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
            child: _getContent(player),
          ),
        ),
      ),
    );
  }
}
