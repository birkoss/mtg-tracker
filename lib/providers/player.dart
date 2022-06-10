import 'package:flutter/material.dart';

class Player with ChangeNotifier {
  final String id;

  Color color;

  List<int> commander = [];
  Map<String, int> data = {};

  Player({
    required this.id,
    required this.color,
  }) {
    reset(40);
  }

  void reset(int startingLives) {
    commander = [0, 0, 0, 0, 0, 0, 0, 0];

    data = {
      'health': startingLives,
      'poison': 0,
      'energy': 0,
      'experience': 0,
    };
  }

  Future<void> refresh(String userToken) async {
    notifyListeners();
  }
}
