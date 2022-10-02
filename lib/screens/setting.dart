import 'package:flutter/material.dart';
import 'package:mtgtracker/providers/player.dart';
import 'package:mtgtracker/providers/players.dart';
import 'package:mtgtracker/screens/colors.dart';
import 'package:mtgtracker/widgets/ui/tile_button.dart';
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

  List<Widget> _getPlayerColorsButtons() {
    List<Widget> widgets = [];

    List<Color> colors = [];
    for (var i = 0; i < context.read<Players>().players.length; i++) {
      colors.add(
        context
            .read<Players>()
            .players[i]
            .getColor(context.read<SettingNotifier>().isDarkTheme),
      );
    }

    for (var i = 0; i < context.read<Players>().players.length; i++) {
      Player player = context.watch<Players>().players[i];
      List<Color> usedColors = List.from(colors);
      usedColors.removeWhere(
        (color) =>
            color ==
            player.getColor(context.read<SettingNotifier>().isDarkTheme),
      );

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(
            right: 20,
            bottom: 20,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.zero, // Set this
              primary:
                  player.getColor(context.read<SettingNotifier>().isDarkTheme),
              padding: const EdgeInsets.all(6), // and this
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                "/setting/colors",
                arguments: SettingColorsScreenArguments(
                  onChanged: (Color newColor) {
                    setState(() {
                      //player.colors[0] = newColor;
                    });

                    player.setColor(newColor);
                    context.read<SettingNotifier>().colors[i] = newColor;
                    context.read<SettingNotifier>().save();

                    context.read<Players>().hasChanged();
                  },
                  usedColors: usedColors,
                  currentColor: player
                      .getColor(context.read<SettingNotifier>().isDarkTheme),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Player " + (i + 1).toString()),
            ),
          ),
        ),
      );
    }

    return widgets;
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
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TileButton(
                          icon: Icons.restart_alt,
                          label: "Reset Game",
                          onPress: () {
                            Navigator.pop(context);
                            widget.onNewGame();
                          },
                        ),
                        TileButton(
                          icon: Icons.people,
                          label: "Choose\nRandom Player",
                          onPress: () {
                            Navigator.pop(context);
                            widget.onPickNewPlayer();
                          },
                        ),
                      ],
                    ),
                    const Divider(
                      height: 30,
                      thickness: 2,
                    ),
                    Text(
                      "Show Additional Counters",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Poison",
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Switch(
                              value: setting.showPoisonCounter,
                              onChanged: (bool value) {
                                setting.togglePoisonCounter();
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Energy",
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Switch(
                              value: setting.showEnergyCounter,
                              onChanged: (bool value) {
                                setting.toggleEnergyCounter();
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Experience",
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Switch(
                              value: setting.showExperienceCounter,
                              onChanged: (bool value) {
                                setting.toggleExperienceCounter();
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    const Divider(
                      height: 30,
                      thickness: 2,
                    ),
                    Text(
                      "Player Colours",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      children: _getPlayerColorsButtons(),
                    )
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
                        // {"value": "5", "label": "5"},
                        // {"value": "6", "label": "6"},
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
                      "Use Dark Theme?",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Switch(
                      value: setting.isDarkTheme,
                      onChanged: (bool value) {
                        setting.toggleDarkTheme();
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Simple Mode?",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Lighter UI, without Commander Damage tracking",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                    ),
                    Switch(
                      value: setting.isSimpleMode,
                      onChanged: (bool value) {
                        setting.toggleSimpleMode();
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Auto Apply Commander Damage?",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Switch(
                      value: setting.autoApplyCommanderDamage,
                      onChanged: (bool value) {
                        setting.changeAutoApplyCommanderDamage(value);
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
