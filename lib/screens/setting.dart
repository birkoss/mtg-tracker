import 'package:flutter/material.dart';

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
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text("Reset"),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("Pick a player"),
                ),
              ],
            ),
            const Text("Number of players"),
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text("3"),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("4"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
