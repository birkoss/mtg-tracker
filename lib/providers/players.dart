import 'dart:math';

import 'package:flutter/material.dart';

import '../providers/player.dart';

final List<Color> lightColors = [
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

final List<Color> darkColors = [
  const Color.fromRGBO(67, 63, 64, 1),
  const Color.fromRGBO(178, 172, 171, 1),
  const Color.fromRGBO(114, 107, 104, 1),
  const Color.fromRGBO(131, 135, 141, 1),
  const Color.fromRGBO(121, 121, 121, 1),
  const Color.fromRGBO(72, 61, 65, 1),
  const Color.fromRGBO(200, 200, 200, 1),
  const Color.fromRGBO(88, 98, 97, 1),
  const Color.fromRGBO(148, 147, 145, 1),
];

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
  void generate(int nbrPlayers) {
    // Generate all Players
    for (int i = 0; i < nbrPlayers; i++) {
      Player player = Player(
        id: i.toString() +
            "-" +
            DateTime.now().millisecondsSinceEpoch.toString(),
      );

      // Set Colors
      player.colors.add(lightColors[players.length]);
      player.colors.add(darkColors[players.length]);

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

  void pickPlayer({bool resetPick = false}) {
    if (resetPick) {
      _diceRollWinner = null;
    } else {
      _diceRollWinner = _players[Random().nextInt(_players.length)];
    }

    notifyListeners();
  }
}
