import 'dart:math';

import 'package:flutter/material.dart';

class Player with ChangeNotifier {
  String id = "";

  List<Color> colors = []; // [0] = Light, [1] = Dark

  bool isDead = false;

  List<Player> opponents = [];
  List<List<int>> commanderDamages = [];

  int _health = 0;
  int get health => _health;
  set health(int newHealth) {
    _health = max(0, newHealth);
  }

  int _poison = 0;
  int get poison => _poison;
  set poison(int newPoison) {
    _poison = max(0, min(newPoison, 10));
  }

  int _energy = 0;
  int get energy => _energy;
  set energy(int newEnergy) {
    _energy = max(0, min(newEnergy, 99));
  }

  int _experience = 0;
  int get experience => _experience;
  set experience(int newExperience) {
    _experience = max(0, min(newExperience, 99));
  }

  int totalCommanders = 1;

  Player({
    required this.id,
  }) {
    reset(40);
  }

  void reset(int startingLives) {
    commanderDamages = [];

    health = startingLives;
    poison = 0;
    totalCommanders = 1;
  }

  Color getColor(bool isDarkTheme) {
    return colors[isDarkTheme ? 1 : 0];
  }

  void setColor(Color color) {
    colors[0] = color;
    notifyListeners();
  }
}
