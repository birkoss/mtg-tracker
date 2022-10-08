import 'package:flutter/material.dart';

import 'package:mtgtracker/providers/player.dart';
import 'package:mtgtracker/widgets/boxes/player/player_box_panel.dart';

class History {
  Player player;
  PanelBoxType type;
  int from;
  int to;
  int lastChanged;

  History({
    required this.player,
    required this.type,
    required this.from,
    required this.to,
    required this.lastChanged,
  });

  void update(int modifier) {
    to += modifier;
    lastChanged = DateTime.now().millisecondsSinceEpoch;
  }
}

class HistoryNotifier extends ChangeNotifier {
  final List<History> _histories = [];

  List<History> get histories => _histories;

  void log({
    required Player player,
    required PanelBoxType type,
    required int from,
    required int to,
  }) {
    int threshold = 2000; // Milliseconds

    int now = DateTime.now().millisecondsSinceEpoch;

    // Has a previous entries within the treeshold ?
    int index = _histories.indexWhere(
      (history) =>
          history.player == player &&
          history.type == type &&
          history.lastChanged + threshold >= now,
    );

    if (index == -1) {
      History history = History(
          from: from,
          to: from + to,
          player: player,
          type: type,
          lastChanged: now);
      _histories.add(history);
    } else {
      _histories[index].update(to);
    }
  }
}
