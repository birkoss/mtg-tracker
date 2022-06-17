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

  final List<Player> _players = [
    Player(id: "1"),
    Player(id: "2"),
    Player(id: "3"),
    Player(id: "4"),
    Player(id: "5"),
    Player(id: "6"),
    Player(id: "7"),
    Player(id: "8"),
  ];

  int _pickedPlayer = 0;

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
    return Scaffold(
      body: Stack(
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
    );
  }
}
