import 'package:flutter/material.dart';
import 'package:mtgtracker/providers/setting.dart';
import 'package:mtgtracker/themes/custom.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = '/settings';
  final int playersNumber;
  final int startingLives;
  final int tableLayout;

  final Function onPickNewPlayer;
  final Function onNewGame;

  const SettingScreen({
    Key? key,
    required this.playersNumber,
    required this.startingLives,
    required this.tableLayout,
    required this.onPickNewPlayer,
    required this.onNewGame,
  }) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int _selectedPlayersNumber = 0;
  int _selectedStartingLives = 0;
  int _selectedTableLayout = 0;

  @override
  void initState() {
    super.initState();

    _selectedPlayersNumber = widget.playersNumber;
    _selectedStartingLives = widget.startingLives;
    _selectedTableLayout = widget.tableLayout;
  }

  List<Widget> generateToggleWidgets({
    required List<Map<String, String>> values,
    required int selectedValue,
    required Function onPress,
  }) {
    List<Widget> widgets = [];

    for (Map<String, String> element in values) {
      widgets.add(
        TextButton(
          onPressed: () {
            //togglePlayersNumber(element);
            onPress(int.parse(element['value'].toString()));
          },
          child: Text(
            element['label'].toString(),
          ),
          style: selectedValue == int.parse(element['value'].toString())
              ? CustomTheme.toggleOnButtonStyle
              : CustomTheme.toggleOffButtonStyle,
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    SettingNotifier setting =
        Provider.of<SettingNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Number of players",
              textAlign: TextAlign.start,
              style: CustomTheme.settingTitle,
            ),
            Wrap(
              spacing: 10,
              children: generateToggleWidgets(
                values: [
                  {"value": "2", "label": "2"},
                  {"value": "3", "label": "3"},
                  {"value": "4", "label": "4"},
                  // {"value": "5", "label": "5"},
                  // {"value": "6", "label": "6"},
                  // {"value": "7", "label": "7"},
                  // {"value": "8", "label": "8"},
                ],
                selectedValue: _selectedPlayersNumber,
                onPress: (playersNumber) {
                  setState(() {
                    _selectedPlayersNumber = playersNumber;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Table Layouts",
              textAlign: TextAlign.start,
              style: CustomTheme.settingTitle,
            ),
            Wrap(
              spacing: 10,
              children: generateToggleWidgets(
                values: [
                  {"value": "1", "label": "Main"},
                  {"value": "2", "label": "Alternative"},
                ],
                selectedValue: _selectedTableLayout,
                onPress: (tableLayout) {
                  setState(() {
                    _selectedTableLayout = tableLayout;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Starting lives",
              textAlign: TextAlign.start,
              style: CustomTheme.settingTitle,
            ),
            Wrap(
              spacing: 10,
              children: generateToggleWidgets(
                values: [
                  {"value": "10", "label": "10"},
                  {"value": "20", "label": "20"},
                  {"value": "30", "label": "30"},
                  {"value": "40", "label": "40"}
                ],
                selectedValue: _selectedStartingLives,
                onPress: (startingLives) {
                  setState(() {
                    _selectedStartingLives = startingLives;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                setting.changePlayersNumber(_selectedPlayersNumber);
                setting.changeStartingLives(_selectedStartingLives);
                setting.changeTableLayout(_selectedTableLayout);

                Navigator.pop(context);

                widget.onNewGame();
              },
              child: const Text("New Game"),
              style: CustomTheme.outlinedButtonStyle,
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                widget.onPickNewPlayer();
              },
              icon: const Icon(Icons.casino),
              label: const Text("Pick a Player at Random"),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setting.toggleDarkTheme();
              },
              icon: const Icon(Icons.casino),
              label: const Text("Toggle Theme"),
            ),
            Text(
              "Theme",
              textAlign: TextAlign.start,
              style: CustomTheme.settingTitle,
            ),
            Wrap(
              spacing: 10,
              children: generateToggleWidgets(
                values: [
                  {"value": "1", "label": "Light"},
                  {"value": "2", "label": "Dark"}
                ],
                selectedValue: setting.isDarkTheme ? 2 : 1,
                onPress: (theme) {
                  // console.log(them)
                  if (setting.isDarkTheme && theme == 1 ||
                      !setting.isDarkTheme && theme == 2) {
                    setting.toggleDarkTheme();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
