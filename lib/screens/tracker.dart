import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mtgtracker/providers/players.dart';
import 'package:mtgtracker/providers/setting.dart';
import 'package:mtgtracker/screens/setting.dart';
import 'package:provider/provider.dart';

import '../providers/player.dart';

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
    SettingNotifier setting =
        Provider.of<SettingNotifier>(context, listen: false);
    setState(() {
      if (_pickedPlayer == 0) {
        _pickedPlayer = Random().nextInt(setting.playersNumber) + 1;

        Timer(
          const Duration(seconds: 2),
          () {
            setState(() {
              _pickedPlayer = 0;
            });
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
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Grid(
                    players: context.read<Players>().players,
                    diceRollWinner: _pickedPlayer,
                  ),
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
