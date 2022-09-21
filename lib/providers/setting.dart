import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingNotifier extends ChangeNotifier {
  SharedPreferences? _pref;

  bool _isReady = false;
  bool get isReady => _isReady;

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  int _playersNumber = 0;
  int get playersNumber => _playersNumber;

  int _tableLayout = 0;
  int get tableLayout => _tableLayout;

  int _startingLives = 0;
  int get startingLives => _startingLives;

  bool _autoApplyCommanderDamage = false;
  bool get autoApplyCommanderDamage => _autoApplyCommanderDamage;

  bool _autoApplyPoisonDamage = false;
  bool get autoApplyPoisonDamage => _autoApplyPoisonDamage;

  SettingNotifier() {
    _load();
  }

  void changeAutoApplyCommanderDamage(autoApplyCommanderDamage) {
    _autoApplyCommanderDamage = autoApplyCommanderDamage;
    _save();
    notifyListeners();
  }

  void changeAutoApplyPoisonDamage(autoApplyPoisonDamage) {
    _autoApplyPoisonDamage = autoApplyPoisonDamage;
    _save();
    notifyListeners();
  }

  void changePlayersNumber(playersNumber) {
    _playersNumber = playersNumber;
    _save();
    notifyListeners();
  }

  void toggleDarkTheme() {
    _isDarkTheme = !_isDarkTheme;
    _save();
    notifyListeners();
  }

  void changeStartingLives(startingLives) {
    _startingLives = startingLives;
    _save();
    notifyListeners();
  }

  void changeTableLayout(tableLayout) {
    _tableLayout = tableLayout;
    _save();
    notifyListeners();
  }

  Future _init() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  Future _load() async {
    await _init();
    _playersNumber = _pref!.getInt("PLAYERS_NUMBER") ?? 4;
    _startingLives = _pref!.getInt("STARTING_LIVES") ?? 40;
    _tableLayout = _pref!.getInt("TABLE_LAYOUT") ?? 1;
    _isDarkTheme = _pref!.getBool("IS_DARK_THEME") ?? false;
    _autoApplyCommanderDamage =
        _pref!.getBool("AUTO_APPLY_COMMANDER_DAMAGE") ?? false;
    _autoApplyPoisonDamage =
        _pref!.getBool("AUTO_APPLY_POISON_DAMAGE") ?? false;
    notifyListeners();

    _isReady = true;
  }

  Future _save() async {
    await _init();
    _pref!.setInt("PLAYERS_NUMBER", _playersNumber);
    _pref!.setInt("STARTING_LIVES", _startingLives);
    _pref!.setInt("TABLE_LAYOUT", _tableLayout);
    _pref!.setBool("IS_DARK_THEME", _isDarkTheme);
    _pref!.setBool("AUTO_APPLY_COMMANDER_DAMAGE", _autoApplyCommanderDamage);
    _pref!.setBool("AUTO_APPLY_POISON_DAMAGE", _autoApplyPoisonDamage);
  }
}
