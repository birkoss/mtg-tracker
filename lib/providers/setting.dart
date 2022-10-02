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

  bool _autoApplyCommanderDamage = true;
  bool get autoApplyCommanderDamage => _autoApplyCommanderDamage;

  bool _isSimpleMode = false;
  bool get isSimpleMode => _isSimpleMode;

  bool _showPoisonCounter = true;
  bool get showPoisonCounter => _showPoisonCounter;

  bool _showEnergyCounter = false;
  bool get showEnergyCounter => _showEnergyCounter;

  bool _showExperienceCounter = false;
  bool get showExperienceCounter => _showExperienceCounter;

  final List<Color> _colors = [];
  List<Color> get colors => _colors;

  SettingNotifier() {
    _load();
  }

  void togglePoisonCounter() {
    _showPoisonCounter = !_showPoisonCounter;
    save();
    notifyListeners();
  }

  void toggleEnergyCounter() {
    _showEnergyCounter = !_showEnergyCounter;
    save();
    notifyListeners();
  }

  void toggleExperienceCounter() {
    _showExperienceCounter = !_showExperienceCounter;
    save();
    notifyListeners();
  }

  void changeAutoApplyCommanderDamage(autoApplyCommanderDamage) {
    _autoApplyCommanderDamage = autoApplyCommanderDamage;
    save();
    notifyListeners();
  }

  void changePlayersNumber(playersNumber) {
    _playersNumber = playersNumber;
    save();
    notifyListeners();
  }

  void toggleDarkTheme() {
    _isDarkTheme = !_isDarkTheme;
    save();
    notifyListeners();
  }

  void toggleSimpleMode() {
    _isSimpleMode = !_isSimpleMode;
    save();
    notifyListeners();
  }

  void changeStartingLives(startingLives) {
    _startingLives = startingLives;
    save();
    notifyListeners();
  }

  void changeTableLayout(tableLayout) {
    _tableLayout = tableLayout;
    save();
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
        _pref!.getBool("AUTO_APPLY_COMMANDER_DAMAGE") ?? true;

    _showEnergyCounter = _pref!.getBool("SHOW_ENERGY_COUNTER") ?? false;
    _showExperienceCounter = _pref!.getBool("SHOW_EXPERIENCE_COUNTER") ?? false;
    _showPoisonCounter = _pref!.getBool("SHOW_POISON_COUNTER") ?? true;

    _isSimpleMode = _pref!.getBool("IS_SIMPLE_MODE") ?? false;

    // Default colors (and if the saved data is INVALID)
    String defaultColors = "4293153375_4288461408_4294283049_4287871966";
    String formattedColor = _pref!.getString("COLORS") ?? defaultColors;

    List<String> textColors = formattedColor.split("_");

    // Must have AT LEAST 4 entries, else use the defaultColors
    if (textColors.length < 4) {
      textColors = defaultColors.split("_");
    }

    // Convert the saved colors value in Color
    for (String colorValue in textColors) {
      _colors.add(Color(int.parse(colorValue)));
    }

    notifyListeners();

    _isReady = true;
  }

  Future save() async {
    await _init();

    _pref!.setInt("PLAYERS_NUMBER", _playersNumber);
    _pref!.setInt("STARTING_LIVES", _startingLives);
    _pref!.setInt("TABLE_LAYOUT", _tableLayout);
    _pref!.setBool("IS_DARK_THEME", _isDarkTheme);
    _pref!.setBool("AUTO_APPLY_COMMANDER_DAMAGE", _autoApplyCommanderDamage);

    _pref!.setBool("SHOW_ENERGY_COUNTER", _showEnergyCounter);
    _pref!.setBool("SHOW_EXPERIENCE_COUNTER", _showExperienceCounter);
    _pref!.setBool("SHOW_POISON_COUNTER", _showPoisonCounter);

    _pref!.setBool("IS_SIMPLE_MODE", _isSimpleMode);

    // Format the colors in a String structure value1_value2_value3_value4
    String formattedColors = "";
    for (Color color in _colors) {
      formattedColors += color.value.toString() + "_";
    }

    // Remove the trailing _ if something is there
    if (formattedColors.endsWith("_")) {
      formattedColors =
          formattedColors.substring(0, formattedColors.length - 1);
    }

    _pref!.setString("COLORS", formattedColors);
  }
}
