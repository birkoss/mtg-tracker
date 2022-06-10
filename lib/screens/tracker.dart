import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
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
  Player? selectedPlayer;

  List<Player> players = [];

  void updateValue(player, newValue) {}

  int _pickedPlayer = 0;

  @override
  void initState() {
    super.initState();

    final List<Color> colors = [
      const Color.fromRGBO(228, 82, 95, 1),
      const Color.fromRGBO(156, 186, 96, 1),
      const Color.fromRGBO(147, 187, 222, 1),
      const Color.fromRGBO(63, 116, 166, 1),
      const Color.fromRGBO(107, 95, 145, 1),
      const Color.fromRGBO(91, 162, 224, 1),
      const Color.fromRGBO(255, 120, 124, 1),
      const Color.fromRGBO(77, 205, 204, 1),
      const Color.fromRGBO(253, 197, 86, 1),
      const Color.fromRGBO(233, 91, 55, 1)
    ];

    players = [
      Player(id: "1", color: colors[0], poison: 0, health: 10),
      Player(id: "2", color: colors[1], poison: 0, health: 20),
      Player(id: "3", color: colors[2], poison: 0, health: 30),
      Player(id: "4", color: colors[3], poison: 0, health: 40),
      Player(id: "5", color: colors[4], poison: 0, health: 50),
      Player(id: "6", color: colors[5], poison: 0, health: 60),
      Player(id: "7", color: colors[6], poison: 0, health: 70),
      Player(id: "8", color: colors[7], poison: 0, health: 80),
    ];
  }

  @override
  Widget build(BuildContext context) {
    print("TrackerScreen.build() PickedPlayer: " + _pickedPlayer.toString());
    //print(players[0].health);
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Grid(
              players: players,
              selectedPlayer: selectedPlayer,
              diceRollWinner: _pickedPlayer,
              onToggleCommanderView: (Player player) {
                setState(
                  () {
                    if (selectedPlayer == player) {
                      selectedPlayer = null;
                    } else {
                      selectedPlayer = player;
                    }
                  },
                );
              },
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                ),
                child: const Icon(
                  Icons.menu,
                  color: Colors.black87,
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
                          onPickNewPlayer: () {
                            setState(() {
                              if (_pickedPlayer == 0) {
                                _pickedPlayer =
                                    Random().nextInt(setting.playersNumber) + 1;

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
                          }),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
