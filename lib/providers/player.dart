import 'package:flutter/material.dart';

class Player with ChangeNotifier {
  final String id;

  Color color;

  int health;
  int poison;

  List<int> commander = [0, 0, 0, 0, 0, 0, 0, 0];
  Map<String, int> data = {
    'health': 40,
    'poison': 0,
  };

  Player({
    required this.id,
    required this.health,
    required this.color,
    required this.poison,
  });

  Future<void> refresh(String userToken) async {
    notifyListeners();
  }
}
