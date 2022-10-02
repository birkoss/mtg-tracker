import 'dart:math';

import 'package:mtgtracker/providers/setting.dart';
import 'package:flutter/material.dart';

import '../providers/player.dart';

class Players extends ChangeNotifier {
  List<Player> _players = [];
  List<Player> get players => _players;

  Player? _diceRollWinner;
  Player? get diceRollWinner => _diceRollWinner;

  void addPlayer(Player player) {
    _players.add(player);

    notifyListeners();
  }

  /* Generate [nbrPlayers] players */
  void generate(
    SettingNotifier setting,
  ) {
    players.clear();

    // Generate all Players
    for (int i = 0; i < setting.playersNumber; i++) {
      Player player = Player(
        id: i.toString() +
            "-" +
            DateTime.now().millisecondsSinceEpoch.toString(),
      );
      player.reset(setting.startingLives);

      // Set Colors
      player.setColor(setting.colors[i]);

      addPlayer(player);
    }

    // Link Opponents in each Players
    for (int i = 0; i < players.length; i++) {
      // Add all other players as Opponents
      for (int j = 0; j < players.length; j++) {
        if (i != j) {
          players[i].opponents.add(players[j]);
        }
      }

      // Setup Commander Damages array for each Opponents
      players[i].commanderDamages = [];
      for (int j = 0; j < players[i].opponents.length; j++) {
        players[i]
            .commanderDamages
            .add([0, 0]); // [0] = Main Commander, [1] = Partner
      }
    }
  }

  void clearPlayers() {
    _players = [];

    notifyListeners();
  }

  void hasChanged() {
    notifyListeners();
  }

  List<int> getActivePlayers() {
    List<int> indexes = [];

    List<Player> activePlayers =
        players.where((player) => !player.isDead).toList();

    for (var player in activePlayers) {
      indexes.add(players.indexOf(player));
    }

    return indexes;
  }

  int pickRandomPlayer() {
    return Random().nextInt(getActivePlayers().length);
  }

  void pickPlayer(int index) {
    if (index == -1) {
      _diceRollWinner = null;
    } else {
      _diceRollWinner = _players[index];
    }

    notifyListeners();
  }
}
