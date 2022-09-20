import 'package:flutter/material.dart';

class Player with ChangeNotifier {
  // [0] = Light Color, [1] = Dark Color
  List<Color> colors = [];

  String id = "";

  bool isDead = false;

  List<Player> opponents = [];

  List<List<int>> commanderDamages = [];
  Map<String, int> data = {};

  Player({
    required this.id,
  }) {
    reset(40);
  }

  void reset(int startingLives) {
    commanderDamages = [];

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
