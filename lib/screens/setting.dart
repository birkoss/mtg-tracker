import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/setting.dart';
import '../widgets/ui/toggles.dart';

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

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("MTG Life Tracker"),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.handyman),
                text: "Tools",
              ),
              Tab(
                icon: Icon(Icons.refresh),
                text: "New Game",
              ),
              Tab(
                icon: Icon(Icons.settings),
                text: "Settings",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onNewGame();
                      },
                      icon: const Icon(Icons.restart_alt),
                      label: const Text("Reset Game"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onPickNewPlayer();
                      },
                      icon: const Icon(Icons.casino),
                      label: const Text("Pick a Player at Random"),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Number of players",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 10),
                    Toggles(
                      defaultValue: setting.playersNumber,
                      values: const [
                        {"value": "2", "label": "2"},
                        {"value": "3", "label": "3"},
                        {"value": "4", "label": "4"},
                        {"value": "5", "label": "5"},
                        {"value": "6", "label": "6"},
                        // {"value": "7", "label": "7"},
                        // {"value": "8", "label": "8"},
                      ],
                      onChanged: (int value) {
                        setState(() {
                          _selectedPlayersNumber = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Table Layouts",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 10),
                    Toggles(
                      defaultValue: setting.tableLayout,
                      values: const [
                        {
                          "value": "1",
                          "label": "Same Side",
                          "icon": "tableLayoutSameSide.svg"
                        },
                        {
                          "value": "2",
                          "label": "All Around",
                          "icon": "tableLayoutAllAround.svg"
                        },
                      ],
                      onChanged: (int value) {
                        setState(() {
                          _selectedTableLayout = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Starting lives",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 10),
                    Toggles(
                      defaultValue: setting.startingLives,
                      values: const [
                        {"value": "10", "label": "10"},
                        {"value": "20", "label": "20"},
                        {"value": "30", "label": "30"},
                        {"value": "40", "label": "40"}
                      ],
                      onChanged: (int value) {
                        setState(() {
                          _selectedStartingLives = value;
                        });
                      },
                    ),
                    const Divider(
                      height: 30,
                      thickness: 2,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        "This will reset the current game!",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setting.changePlayersNumber(_selectedPlayersNumber);
                        setting.changeStartingLives(_selectedStartingLives);
                        setting.changeTableLayout(_selectedTableLayout);

                        Navigator.pop(context);
                        widget.onNewGame();
                      },
                      icon: const Icon(Icons.check),
                      label: const Text("New Game"),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Theme",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 10),
                    Toggles(
                      defaultValue: setting.isDarkTheme ? 2 : 1,
                      values: const [
                        {"value": "1", "label": "Light"},
                        {"value": "2", "label": "Dark"}
                      ],
                      onChanged: (int value) {
                        if (setting.isDarkTheme && value == 1 ||
                            !setting.isDarkTheme && value == 2) {
                          setting.toggleDarkTheme();
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Auto Apply Commander Damage?",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 10),
                    Toggles(
                      defaultValue: setting.autoApplyCommanderDamage ? 1 : 0,
                      values: const [
                        {"value": "0", "label": "No"},
                        {"value": "1", "label": "Yes"}
                      ],
                      onChanged: (int value) {
                        setting.changeAutoApplyCommanderDamage(value == 1);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
