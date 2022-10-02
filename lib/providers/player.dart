import 'dart:math';

import 'package:flutter/material.dart';

class Player with ChangeNotifier {
  String id = "";

  Color color = Colors.red;

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

  int _commanderTax = 0;
  int get commanderTax => _commanderTax;
  set commanderTax(int newCommanderTax) {
    _commanderTax = max(0, min(newCommanderTax, 99));
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
    commanderTax = 0;
  }

  Color getColor() {
    return color;
  }

  void setColor(Color newColor) {
    color = newColor;
    notifyListeners();
  }
}
