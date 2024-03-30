import 'package:flutter/material.dart';

import '../providers/player.dart';

import '../widgets/boxes/player/player_box_panel.dart';

class History {
  Player player;
  PanelBoxType type;
  int from;
  int to;
  int lastChanged;
  Player? opponent;
  int commanderOrPartner;

  History({
    required this.player,
    required this.type,
    required this.from,
    required this.to,
    required this.lastChanged,
    this.opponent,
    this.commanderOrPartner = 0,
  });

  void update(int modifier) {
    to += modifier;
    lastChanged = DateTime.now().millisecondsSinceEpoch;
  }
}

class HistoryNotifier extends ChangeNotifier {
  final List<History> _histories = [];

  final List<int> _separations = [];

  List<History> get histories => _histories;

  bool hasSplitted(int index) {
    return _separations.contains(index);
  }

  void clear() {
    _histories.clear();
    _separations.clear();
  }

  void newGame() {
    _separations.add(_histories.length);
  }

  void log({
    required Player player,
    required PanelBoxType type,
    required int from,
    required int to,
    Player? opponent,
    int commanderOrPartner = 0,
  }) {
    int threshold = 2000; // Milliseconds

    int now = DateTime.now().millisecondsSinceEpoch;

    // Has a previous entries within the treeshold ?
    int index = _histories.indexWhere(
      (history) =>
          history.player == player &&
          history.type == type &&
          history.lastChanged + threshold >= now &&
          history.opponent == opponent &&
          history.commanderOrPartner == commanderOrPartner,
    );

    if (index == -1) {
      History history = History(
        from: from,
        to: from + to,
        player: player,
        type: type,
        lastChanged: now,
        opponent: opponent,
        commanderOrPartner: commanderOrPartner,
      );
      _histories.add(history);
    } else {
      _histories[index].update(to);
      // Remove the entries if the values are not changed
      if (_histories[index].from == _histories[index].to) {
        _histories.removeAt(index);
      }
    }
  }
}
