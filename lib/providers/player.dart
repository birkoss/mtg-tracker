import 'package:flutter/material.dart';
import 'package:mtgtracker/providers/setting.dart';
import 'package:provider/provider.dart';

class Player with ChangeNotifier {
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

  final String id;

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

  Color getColor(BuildContext context) {
    int index = int.parse(id) - 1;

    SettingNotifier setting =
        Provider.of<SettingNotifier>(context, listen: false);

    return setting.isDarkTheme ? darkColors[index] : lightColors[index];
  }

  Future<void> refresh() async {
    notifyListeners();
  }

  void updateTotalCommanders(int total) {
    data['totalCommanders'] = total;

    notifyListeners();
  }
}
