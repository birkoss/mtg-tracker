import 'package:flutter/material.dart';
import 'package:mtgtracker/providers/setting.dart';
import 'package:mtgtracker/themes/custom.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = '/settings';
  final int playersNumber;
  final int startingLives;

  const SettingScreen({
    Key? key,
    required this.playersNumber,
    required this.startingLives,
  }) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int _selectedPlayersNumber = 0;
  int _selectedStartingLives = 0;

  @override
  void initState() {
    super.initState();

    _selectedPlayersNumber = widget.playersNumber;
    _selectedStartingLives = widget.startingLives;
  }

  List<Widget> generateToggleWidgets({
    required List<int> values,
    required int selectedValue,
    required Function onPress,
  }) {
    List<Widget> widgets = [];

    for (int element in values) {
      widgets.add(
        TextButton(
          onPressed: () {
            //togglePlayersNumber(element);
            onPress(element);
          },
          child: Text(
            element.toString(),
          ),
          style: selectedValue == element
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
                values: [2, 3, 4, 5, 6, 7, 8],
                selectedValue: _selectedPlayersNumber,
                onPress: (playersNumber) {
                  setState(() {
                    _selectedPlayersNumber = playersNumber;
                  });
                },
              ),
            ),
            Text(
              "Starting lives",
              textAlign: TextAlign.start,
              style: CustomTheme.settingTitle,
            ),
            Wrap(
              spacing: 10,
              children: generateToggleWidgets(
                values: [10, 20, 30, 40],
                selectedValue: _selectedStartingLives,
                onPress: (startingLives) {
                  setState(() {
                    _selectedStartingLives = startingLives;
                  });
                },
              ),
            ),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    setting.changePlayersNumber(_selectedPlayersNumber);
                    Navigator.pop(context);
                  },
                  child: const Text("New Game"),
                  style: CustomTheme.outlinedButtonStyle,
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text("Pick a player"),
                  style: CustomTheme.outlinedButtonStyle,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
