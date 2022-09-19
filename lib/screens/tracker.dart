import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/player.dart';
import '../providers/players.dart';
import '../providers/setting.dart';
import '../screens/setting.dart';
import '../widgets/grid.dart';

class TrackerScreen extends StatefulWidget {
  static const routeName = '/players';

  const TrackerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  int _pickedPlayer = 0;

  // @TODO REMOVE FROM HERE
  void _newGame() {
    SettingNotifier setting =
        Provider.of<SettingNotifier>(context, listen: false);

    for (Player player in context.read<Players>().players) {
      player.reset(setting.startingLives);
    }

    _pickNewPlayer();
  }

  void _pickNewPlayer() {
    print("New player pick...");
    context.read<Players>().pickPlayer();

    print(context.read<Players>().diceRollWinner);
    Timer(
      const Duration(seconds: 2),
      () {
        context.read<Players>().pickPlayer(resetPick: true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Container(
            color: Theme.of(context).canvasColor,
            child: Stack(
              children: [
                const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Grid(),
                ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).canvasColor,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                    ),
                    child: Icon(
                      Icons.menu,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      size: 30,
                    ),
                    onPressed: () {
                      SettingNotifier setting =
                          Provider.of<SettingNotifier>(context, listen: false);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingScreen(
                            tableLayout: setting.tableLayout,
                            startingLives: setting.startingLives,
                            playersNumber: setting.playersNumber,
                            onPickNewPlayer: _pickNewPlayer,
                            onNewGame: _newGame,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
