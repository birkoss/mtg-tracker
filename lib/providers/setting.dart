import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingNotifier extends ChangeNotifier {
  SharedPreferences? _pref;

  bool _isReady = false;
  bool get isReady => _isReady;

  int _playersNumber = 0;
  int get playersNumber => _playersNumber;

  SettingNotifier() {
    _load();
  }

  void changePlayersNumber(playersNumber) {
    _playersNumber = playersNumber;
    _save();
    notifyListeners();
  }

  Future _init() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  Future _load() async {
    await _init();
    _playersNumber = _pref!.getInt("PLAYERS_NUMBER") ?? 4;
    notifyListeners();

    _isReady = true;
  }

  Future _save() async {
    await _init();
    _pref!.setInt("PLAYERS_NUMBER", _playersNumber);
  }
}
