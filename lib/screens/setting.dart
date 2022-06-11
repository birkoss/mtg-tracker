import 'package:flutter/material.dart';
import 'package:mtgtracker/providers/setting.dart';
import 'package:mtgtracker/widgets/ui/toggles.dart';
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
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Toggles(
              defaultValue: setting.playersNumber.toString(),
              values: const [
                {"value": "2", "label": "2"},
                {"value": "3", "label": "3"},
                {"value": "4", "label": "4"},
                {"value": "5", "label": "5"},
                {"value": "6", "label": "6"},
                // {"value": "7", "label": "7"},
                // {"value": "8", "label": "8"},
              ],
              onChanged: (String value) {
                setting.changePlayersNumber(int.parse(value));
                widget.onNewGame();
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Table Layouts",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Toggles(
              defaultValue: setting.tableLayout.toString(),
              values: const [
                {"value": "1", "label": "Same Side"},
                {"value": "2", "label": "All Around"},
              ],
              onChanged: (String value) {
                setting.changeTableLayout(int.parse(value));
                widget.onNewGame();
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Starting lives",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Toggles(
              defaultValue: setting.startingLives.toString(),
              values: const [
                {"value": "10", "label": "10"},
                {"value": "20", "label": "20"},
                {"value": "30", "label": "30"},
                {"value": "40", "label": "40"}
              ],
              onChanged: (String value) {
                setting.changeStartingLives(int.parse(value));
                widget.onNewGame();
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setting.changePlayersNumber(_selectedPlayersNumber);
                setting.changeStartingLives(_selectedStartingLives);
                setting.changeTableLayout(_selectedTableLayout);

                Navigator.pop(context);

                widget.onNewGame();
              },
              child: const Text("New Game"),
            ),
            const Divider(
              height: 30,
              thickness: 2,
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                widget.onPickNewPlayer();
              },
              icon: const Icon(Icons.casino),
              label: const Text("Pick a Player at Random"),
            ),
            const Divider(
              height: 30,
              thickness: 2,
            ),
            Text(
              "Theme",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Toggles(
              defaultValue: setting.isDarkTheme ? "2" : "1",
              values: const [
                {"value": "1", "label": "Light"},
                {"value": "2", "label": "Dark"}
              ],
              onChanged: (String value) {
                if (setting.isDarkTheme && value == "1" ||
                    !setting.isDarkTheme && value == "2") {
                  setting.toggleDarkTheme();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
