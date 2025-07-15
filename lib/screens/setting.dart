import 'package:flutter/material.dart';
import 'package:mtgtracker/providers/history.dart';
import 'package:provider/provider.dart';

import '../providers/player.dart';
import '../providers/players.dart';
import '../providers/setting.dart';

import '../screens/colors.dart';

import '../widgets/ui/tile_button.dart';
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
        context.read<Players>().players[i].getColor(),
      );
    }

    for (var i = 0; i < context.read<Players>().players.length; i++) {
      Player player = context.watch<Players>().players[i];
      List<Color> usedColors = List.from(colors);
      usedColors.removeWhere(
        (color) => color == player.getColor(),
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
              backgroundColor: player.getColor(),
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
                  currentColor: player.getColor(),
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

    // Generate the players choice from the SettingNotifier
    List<Map<String, String>> nbrPlayers = [];
    for (int i = 2; i <= SettingNotifier.maximumPlayers; i++) {
      nbrPlayers.add({"value": i.toString(), "label": i.toString()});
    }

    bool warnAboutTracker = false;

    if (_selectedPlayersNumber > 6) {
      warnAboutTracker = true;
    }
    // All Around is NOT possible with all the visible trackers
    if (_selectedPlayersNumber > 4 && _selectedTableLayout == 2) {
      warnAboutTracker = true;
    }

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
                            if (setting.clearHistoryOnNewGame) {
                              context.read<HistoryNotifier>().clear();
                            } else {
                              context.read<HistoryNotifier>().newGame();
                            }
                            Navigator.pop(context);
                            widget.onNewGame();
                          },
                        ),
                        TileButton(
                          icon: Icons.people,
                          label: "Choose\nRandom Player",
                          isDisabled: context.read<Players>().isPickingPlayer,
                          onPress: () {
                            Navigator.pop(context);
                            widget.onPickNewPlayer();
                          },
                        ),
                        TileButton(
                          icon: Icons.history,
                          label: "History",
                          onPress: () {
                            Navigator.pushNamed(context, '/history');
                          },
                        ),
                      ],
                    ),
                    const Divider(
                      height: 30,
                      thickness: 2,
                    ),
                    Text(
                      "Show Additional Trackers",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Those counters will be added, depending on Commanders and Partners, in the same order they are presented here. \n\nIf there is no more space, a navigation system will be available..",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Commander Damage",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Switch(
                          value: setting.showCommanderDamage,
                          onChanged: (bool value) {
                            setting.toggleCommanderDamage();
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Commander Tax",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Switch(
                          value: setting.showCommanderTax,
                          onChanged: (bool value) {
                            setting.toggleCommanderTax();
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Poison",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Switch(
                          value: setting.showPoisonCounter,
                          onChanged: (bool value) {
                            setting.togglePoisonCounter();
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Energy",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Switch(
                          value: setting.showEnergyCounter,
                          onChanged: (bool value) {
                            setting.toggleEnergyCounter();
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Experience",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Switch(
                          value: setting.showExperienceCounter,
                          onChanged: (bool value) {
                            setting.toggleExperienceCounter();
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rad",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Switch(
                          value: setting.showRadCounter,
                          onChanged: (bool value) {
                            setting.toggleRadCounter();
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Storm",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Switch(
                          value: setting.showStormCounter,
                          onChanged: (bool value) {
                            setting.toggleStormCounter();
                          },
                        ),
                      ],
                    ),
                    const Divider(
                      height: 30,
                      thickness: 2,
                    ),
                    Text(
                      "Player Colours",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    Toggles(
                      defaultValue: setting.playersNumber,
                      values: nbrPlayers,
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
                      style: Theme.of(context).textTheme.bodyLarge,
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
                      style: Theme.of(context).textTheme.bodyLarge,
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
                    if (warnAboutTracker)
                      const Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              "This layout will not have the individual trackers for each players. An update will allow it down the road!",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Divider(
                            height: 30,
                            thickness: 2,
                          )
                        ],
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
                        if (setting.clearHistoryOnNewGame) {
                          context.read<HistoryNotifier>().clear();
                        } else {
                          context.read<HistoryNotifier>().newGame();
                        }
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
                      "Global Settings",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Use Dark Theme?",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyLarge,
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
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Lighter UI, without additional trackers",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                      "Always Pick Random Player on New Game?",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Switch(
                      value: setting.pickPlayerOnNewGame,
                      onChanged: (bool value) {
                        setting.togglePickPlayerOnNewGame();
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Clear History on New Game?",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Switch(
                      value: setting.clearHistoryOnNewGame,
                      onChanged: (bool value) {
                        setting.toggleClearHistoryOnNewGame();
                      },
                    ),
                    const Divider(
                      height: 30,
                      thickness: 2,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Trackers Settings",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Auto Apply Commander Damage?",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Switch(
                      value: setting.autoApplyCommanderDamage,
                      onChanged: (bool value) {
                        setting.changeAutoApplyCommanderDamage(value);
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Auto Eliminate Player on Commander Damage or Normal Damage?",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Switch(
                      value: setting.autoElimitatePlayer,
                      onChanged: (bool value) {
                        setting.toggleAutoEliminatePlayer();
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Revert to life tracker after 5 seconds of inactivity after assigning Commander Damage?",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Switch(
                      value: setting.autoCloseTracker,
                      onChanged: (bool value) {
                        setting.toggleAutoCloseTracker();
                      },
                    )
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
