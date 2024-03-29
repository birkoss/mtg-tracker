import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingNotifier extends ChangeNotifier {
  static Map<String, List<Color>> colorSchemes = {
    "light": const [
      Color.fromRGBO(228, 82, 95, 1),
      Color.fromRGBO(156, 186, 96, 1),
      Color.fromRGBO(245, 143, 41, 1),
      Color.fromRGBO(147, 187, 222, 1),
      Color.fromRGBO(63, 116, 166, 1),
      Color.fromRGBO(107, 95, 145, 1),
      Color.fromRGBO(91, 162, 224, 1),
      Color.fromRGBO(255, 120, 124, 1),
      Color.fromRGBO(77, 205, 204, 1),
      Color.fromRGBO(253, 197, 86, 1),
      Color.fromRGBO(233, 91, 55, 1),
      //Color.fromRGBO(255, 0, 255, 1), // Only for test!
    ],
    "dark": const [
      Color.fromRGBO(67, 63, 64, 1),
      Color.fromRGBO(178, 172, 171, 1),
      Color.fromRGBO(114, 107, 104, 1),
      Color.fromRGBO(131, 135, 141, 1),
      Color.fromRGBO(121, 121, 121, 1),
      Color.fromRGBO(72, 61, 65, 1),
      Color.fromRGBO(200, 200, 200, 1),
      Color.fromRGBO(88, 98, 97, 1),
      Color.fromRGBO(148, 147, 145, 1),
    ],
  };

  static int maximumPlayers = 8;

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

  bool _autoEliminatePlayer = false;
  bool get autoElimitatePlayer => _autoEliminatePlayer;

  bool _autoCloseTracker = false;
  bool get autoCloseTracker => _autoCloseTracker;

  bool _isSimpleMode = false;
  bool get isSimpleMode => _isSimpleMode;

  bool _showPoisonCounter = true;
  bool get showPoisonCounter => _showPoisonCounter;

  bool _showEnergyCounter = false;
  bool get showEnergyCounter => _showEnergyCounter;

  bool _showExperienceCounter = false;
  bool get showExperienceCounter => _showExperienceCounter;

  bool _showStormCounter = false;
  bool get showStormCounter => _showStormCounter;

  bool _showRadCounter = false;
  bool get showRadCounter => _showRadCounter;

  bool _showCommanderTax = false;
  bool get showCommanderTax => _showCommanderTax;

  bool _showCommanderDamage = true;
  bool get showCommanderDamage => _showCommanderDamage;

  bool _pickPlayerOnNewGame = false;
  bool get pickPlayerOnNewGame => _pickPlayerOnNewGame;

  bool _clearHistoryOnNewGame = false;
  bool get clearHistoryOnNewGame => _clearHistoryOnNewGame;

  final List<Color> _colors = [];
  List<Color> get colors => _colors;

  SettingNotifier() {
    _load();
  }

  void toggleClearHistoryOnNewGame() {
    _clearHistoryOnNewGame = !_clearHistoryOnNewGame;
    save();
    notifyListeners();
  }

  void togglePickPlayerOnNewGame() {
    _pickPlayerOnNewGame = !_pickPlayerOnNewGame;
    save();
    notifyListeners();
  }

  void toggleCommanderTax() {
    _showCommanderTax = !_showCommanderTax;
    save();
    notifyListeners();
  }

  void toggleCommanderDamage() {
    _showCommanderDamage = !_showCommanderDamage;
    save();
    notifyListeners();
  }

  void togglePoisonCounter() {
    _showPoisonCounter = !_showPoisonCounter;
    save();
    notifyListeners();
  }

  void toggleRadCounter() {
    _showRadCounter = !_showRadCounter;
    save();
    notifyListeners();
  }

  void toggleStormCounter() {
    _showStormCounter = !_showStormCounter;
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

  void toggleAutoEliminatePlayer() {
    _autoEliminatePlayer = !_autoEliminatePlayer;
    save();
    notifyListeners();
  }

  void toggleAutoCloseTracker() {
    _autoCloseTracker = !_autoCloseTracker;
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

    _autoEliminatePlayer = _pref!.getBool("AUTO_ELIMINATE_PLAYER") ?? false;

    _showEnergyCounter = _pref!.getBool("SHOW_ENERGY_COUNTER") ?? false;
    _showExperienceCounter = _pref!.getBool("SHOW_EXPERIENCE_COUNTER") ?? false;
    _showPoisonCounter = _pref!.getBool("SHOW_POISON_COUNTER") ?? true;
    _showCommanderTax = _pref!.getBool("SHOW_COMMANDER_TAX") ?? true;
    _showCommanderDamage = _pref!.getBool("SHOW_COMMANDER_DAMAGE") ?? true;
    _showStormCounter = _pref!.getBool("SHOW_STORM_COUNTER") ?? false;
    _showRadCounter = _pref!.getBool("SHOW_RAD_COUNTER") ?? false;

    _isSimpleMode = _pref!.getBool("IS_SIMPLE_MODE") ?? false;

    _pickPlayerOnNewGame = _pref!.getBool("PICK_PLAYER_ON_NEW_GAME") ?? true;
    _clearHistoryOnNewGame =
        _pref!.getBool("CLEAR_HISTORY_ON_NEW_GAME") ?? false;

    // Pick defaultColors based on the maximum players number
    List<String> defaultColors = [];
    for (int i = 0; i < SettingNotifier.maximumPlayers; i++) {
      defaultColors.add(
        SettingNotifier.colorSchemes['light']![i].value.toString(),
      );
    }

    // Load save colors
    String formattedColor = _pref!.getString("COLORS") ?? defaultColors[0];
    List<String> textColors = formattedColor.split("_");

    // Fill the colors to the maximum players available with remaining default colors
    if (textColors.length < defaultColors.length) {
      // Remove the choosen color from the list to prevent duplicate
      for (String colorValue in textColors) {
        defaultColors.remove(colorValue);
      }

      // Add remaining default colors
      for (int i = 0; i < defaultColors.length; i++) {
        textColors.add(defaultColors[i]);
      }
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
    _pref!.setBool("AUTO_ELIMINATE_PLAYER", _autoEliminatePlayer);

    _pref!.setBool("SHOW_ENERGY_COUNTER", _showEnergyCounter);
    _pref!.setBool("SHOW_EXPERIENCE_COUNTER", _showExperienceCounter);
    _pref!.setBool("SHOW_POISON_COUNTER", _showPoisonCounter);
    _pref!.setBool("SHOW_COMMANDER_TAX", _showCommanderTax);
    _pref!.setBool("SHOW_STORM_COUNTER", _showStormCounter);
    _pref!.setBool("SHOW_COMMANDER_DAMAGE", _showCommanderDamage);
    _pref!.setBool("SHOW_RAD_COUNTER", _showRadCounter);

    _pref!.setBool("PICK_PLAYER_ON_NEW_GAME", _pickPlayerOnNewGame);
    _pref!.setBool("CLEAR_HISTORY_ON_NEW_GAME", _clearHistoryOnNewGame);

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
