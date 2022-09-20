import 'package:flutter/material.dart';
import 'package:mtgtracker/providers/setting.dart';
import 'package:provider/provider.dart';

class Player with ChangeNotifier {
  final String id;

  // [0] = Light Color, [1] = Dark Color
  List<Color> colors = [];

  // Auto-generated when creating a new Player
  late String keyId = "";

  bool isDead = false;

  List<Player> opponents = [];

  List<List<int>> commander = [];
  Map<String, int> data = {};

  Player({
    required this.id,
  }) {
    reset(40);
  }

  void reset(int startingLives) {
    // Support for Partners
    // [0] = Main commander
    // [1] = Partner
    commander = [
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
    ];

    data = {
      'health': startingLives,
      'poison': 0,
      'energy': 0,
      'experience': 0,
      'totalCommanders': 1,
    };
  }

  Color getColor(bool isDarkTheme) {
    return colors[isDarkTheme ? 1 : 0];
  }

  Future<void> refresh() async {
    notifyListeners();
  }

  void updateTotalCommanders(int total) {
    data['totalCommanders'] = total;

    notifyListeners();
  }
}
