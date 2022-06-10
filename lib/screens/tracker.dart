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
  Player? _selectedPlayer;

  List<Player> _players = [];

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

    _players = [
      Player(id: "1", color: colors[0]),
      Player(id: "2", color: colors[1]),
      Player(id: "3", color: colors[2]),
      Player(id: "4", color: colors[3]),
      Player(id: "5", color: colors[4]),
      Player(id: "6", color: colors[5]),
      Player(id: "7", color: colors[6]),
      Player(id: "8", color: colors[7]),
    ];
  }

  void _newGame() {
    SettingNotifier setting =
        Provider.of<SettingNotifier>(context, listen: false);

    for (Player player in _players) {
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

  void _toggleCommanderView(Player player) {
    setState(() {
      if (_selectedPlayer == player) {
        _selectedPlayer = null;
      } else {
        _selectedPlayer = player;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("TrackerScreen.build() PickedPlayer: " + _pickedPlayer.toString());

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Grid(
              players: _players,
              selectedPlayer: _selectedPlayer,
              diceRollWinner: _pickedPlayer,
              onToggleCommanderView: _toggleCommanderView,
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).appBarTheme.backgroundColor,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                ),
                child: Icon(
                  Icons.menu,
                  color: Theme.of(context).appBarTheme.foregroundColor,
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
    );
  }
}
