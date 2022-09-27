import 'package:flutter/material.dart';

import '../providers/player.dart';
import '../providers/setting.dart';
import '../models/layout.dart';

class LayoutNotifier extends ChangeNotifier {
  final List<List<Layout>> _rows = [];
  List<List<Layout>> get rows => _rows;

  void generate(List<Player> players, SettingNotifier setting) {
    _rows.clear();

    switch (players.length) {
      case 2:
        if (setting.tableLayout == 2) {
          _rows.add([
            Layout(player: players[0], direction: LayoutDirection.top),
          ]);
          _rows.add([
            Layout(player: players[1], direction: LayoutDirection.bottom),
          ]);
        } else {
          _rows.add([
            Layout(player: players[0], direction: LayoutDirection.left),
            Layout(player: players[1], direction: LayoutDirection.right),
          ]);
        }

        break;
      case 3:
        if (setting.tableLayout == 2) {
          _rows.add([
            Layout(player: players[0], direction: LayoutDirection.left),
            Layout(player: players[1], direction: LayoutDirection.right),
          ]);

          _rows.add([
            Layout(player: players[2], direction: LayoutDirection.bottom),
          ]);
        } else {
          _rows.add([
            Layout(player: players[0], direction: LayoutDirection.left),
            Layout(player: players[1], direction: LayoutDirection.right),
          ]);

          _rows.add([
            Layout(player: null, direction: null),
            Layout(player: players[2], direction: LayoutDirection.right),
          ]);
        }

        break;
      case 4:
        if (setting.tableLayout == 2) {
          _rows.add([
            Layout(player: players[0], direction: LayoutDirection.top),
          ]);

          _rows.add([
            Layout(player: players[1], direction: LayoutDirection.left),
            Layout(player: players[2], direction: LayoutDirection.right),
          ]);

          _rows.add([
            Layout(player: players[3], direction: LayoutDirection.bottom),
          ]);
        } else {
          _rows.add([
            Layout(player: players[0], direction: LayoutDirection.left),
            Layout(player: players[1], direction: LayoutDirection.right),
          ]);

          _rows.add([
            Layout(player: players[3], direction: LayoutDirection.left),
            Layout(player: players[2], direction: LayoutDirection.right),
          ]);
        }

        break;
      case 5:
        if (setting.tableLayout == 2) {
          _rows.add([
            Layout(player: players[0], direction: LayoutDirection.left),
            Layout(player: players[1], direction: LayoutDirection.right),
          ]);

          _rows.add([
            Layout(player: players[2], direction: LayoutDirection.left),
            Layout(player: players[3], direction: LayoutDirection.right),
          ]);

          _rows.add([
            Layout(player: players[4], direction: LayoutDirection.bottom),
          ]);
        } else {
          _rows.add([
            Layout(player: players[0], direction: LayoutDirection.left),
            Layout(player: players[1], direction: LayoutDirection.right),
          ]);

          _rows.add([
            Layout(player: players[2], direction: LayoutDirection.left),
            Layout(player: players[3], direction: LayoutDirection.right),
          ]);

          _rows.add([
            Layout(player: players[4], direction: LayoutDirection.left),
            Layout(player: null, direction: null),
          ]);
        }
        break;
      case 6:
        if (setting.tableLayout == 2) {
          _rows.add([
            Layout(player: players[0], direction: LayoutDirection.top),
          ]);

          _rows.add([
            Layout(player: players[1], direction: LayoutDirection.left),
            Layout(player: players[2], direction: LayoutDirection.right),
          ]);

          _rows.add([
            Layout(player: players[3], direction: LayoutDirection.left),
            Layout(player: players[4], direction: LayoutDirection.right),
          ]);

          _rows.add([
            Layout(player: players[5], direction: LayoutDirection.bottom),
          ]);
        } else {
          _rows.add([
            Layout(player: players[0], direction: LayoutDirection.left),
            Layout(player: players[1], direction: LayoutDirection.right),
          ]);

          _rows.add([
            Layout(player: players[2], direction: LayoutDirection.left),
            Layout(player: players[3], direction: LayoutDirection.right),
          ]);

          _rows.add([
            Layout(player: players[4], direction: LayoutDirection.left),
            Layout(player: players[5], direction: LayoutDirection.right),
          ]);
        }
        break;
      case 7:
        _rows.add([
          Layout(player: players[0], direction: LayoutDirection.left),
          Layout(player: players[1], direction: LayoutDirection.right),
        ]);

        _rows.add([
          Layout(player: players[2], direction: LayoutDirection.left),
          Layout(player: players[3], direction: LayoutDirection.right),
        ]);

        _rows.add([
          Layout(player: players[4], direction: LayoutDirection.left),
          Layout(player: players[5], direction: LayoutDirection.right),
        ]);

        _rows.add([
          Layout(player: players[6], direction: LayoutDirection.bottom),
        ]);
        break;
      case 8:
        _rows.add([
          Layout(player: players[0], direction: LayoutDirection.top),
        ]);

        _rows.add([
          Layout(player: players[1], direction: LayoutDirection.left),
          Layout(player: players[2], direction: LayoutDirection.right),
        ]);

        _rows.add([
          Layout(player: players[3], direction: LayoutDirection.left),
          Layout(player: players[4], direction: LayoutDirection.right),
        ]);

        _rows.add([
          Layout(player: players[5], direction: LayoutDirection.left),
          Layout(player: players[6], direction: LayoutDirection.right),
        ]);

        _rows.add([
          Layout(player: players[7], direction: LayoutDirection.bottom),
        ]);
        break;
      default:
        _rows.add([
          Layout(player: players[1], direction: LayoutDirection.bottom),
        ]);
    }

    notifyListeners();
  }
}
