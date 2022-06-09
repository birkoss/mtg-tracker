import 'package:flutter/material.dart';
import 'package:mtgtracker/themes/custom.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = '/settings';

  const SettingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    //print(players[0].health);
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
              "Number of players.",
              textAlign: TextAlign.start,
              style: CustomTheme.settingTitle,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text("3"),
                  style: CustomTheme.toggleOffButtonStyle,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("4"),
                  style: CustomTheme.toggleOnButtonStyle,
                ),
              ],
            ),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: const Text("Reset"),
                  style: CustomTheme.outlinedButtonStyle,
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: Text("Pick a player"),
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
