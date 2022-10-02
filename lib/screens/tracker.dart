import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mtgtracker/providers/layout.dart';
import 'package:provider/provider.dart';

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
  // @TODO REMOVE FROM HERE
  void _newGame() {
    context.read<Players>().generate(
          context.read<SettingNotifier>(),
        );

    context.read<LayoutNotifier>().generate(
          context.read<Players>().players,
          context.read<SettingNotifier>(),
        );

    _pickNewPlayer();
  }

  void _pickNewPlayer() {
    List<int> playersIndex = [];

    List<int> indexes = context.read<Players>().getActivePlayers();
    for (int j = 0; j < 4; j++) {
      for (int i = 0; i < indexes.length; i++) {
        playersIndex.add(indexes[i]);
      }
    }

    int winner = context.read<Players>().pickRandomPlayer();
    for (int i in indexes) {
      playersIndex.add(i);
      if (i == winner) {
        break;
      }
    }

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      context.read<Players>().pickPlayer(playersIndex.removeAt(0));

      // Stop the timer when it matches a condition
      if (playersIndex.isEmpty) {
        timer.cancel();

        Timer(
          const Duration(seconds: 2),
          () {
            context.read<Players>().pickPlayer(-1);
          },
        );
      }
    });
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
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                  child: Grid(),
                ),
                Align(
                  alignment:
                      context.watch<SettingNotifier>().playersNumber == 3 &&
                              context.watch<SettingNotifier>().tableLayout == 2
                          ? const Alignment(0, 0.21)
                          : Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).canvasColor,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                      shadowColor: Colors.transparent,
                    ),
                    child: Icon(
                      Icons.menu,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      size: 30,
                    ),
                    onPressed: () {
                      SettingNotifier setting = context.read<SettingNotifier>();
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
