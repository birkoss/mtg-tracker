import 'package:flutter/material.dart';
import 'package:mtgtracker/providers/setting.dart';
import 'package:mtgtracker/themes/custom.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = '/settings';
  final int playersNumber;

  const SettingScreen({
    Key? key,
    required this.playersNumber,
  }) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int _selectedPlayersNumber = 0;

  @override
  void initState() {
    super.initState();

    _selectedPlayersNumber = widget.playersNumber;
  }

  void togglePlayersNumber(playerNumber) {
    setState(() {
      _selectedPlayersNumber = playerNumber;
    });
  }

  List<Widget> generatePlayersNumberWidgets() {
    List<Widget> widgets = [];

    for (int element in [2, 3, 4, 5, 6, 7, 8]) {
      widgets.add(
        TextButton(
          onPressed: () {
            togglePlayersNumber(element);
          },
          child: Text(
            element.toString(),
          ),
          style: _selectedPlayersNumber == element
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
              children: generatePlayersNumberWidgets(),
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
