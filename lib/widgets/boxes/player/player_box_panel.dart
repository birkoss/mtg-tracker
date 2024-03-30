import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../providers/history.dart';
import '../../../providers/player.dart';
import '../../../providers/players.dart';
import '../../../providers/setting.dart';

import '../amount.dart';
import '../../dynamic_pressable_button.dart';
import '../../mtgicons.dart';
import '../../pressable_button.dart';

// What are we modifying in the Panel
enum PanelBoxType {
  commander,
  normal,
  poison,
  energy,
  experience,
  commanderTax,
  partnerTax,
  storm,
  rad,
}

class PanelBoxPanel extends StatefulWidget {
  final VoidCallback showSettings;

  const PanelBoxPanel({
    Key? key,
    required this.showSettings,
  }) : super(key: key);

  @override
  State<PanelBoxPanel> createState() => _PanelBoxPanelState();
}

class _PanelBoxPanelState extends State<PanelBoxPanel> {
  int _trackerPage = 0;

  // [0] = Opponent, [1] = Commander,Partner (0,1)
  List<int> _selectedCommander = [-1, 0];

  PanelBoxType _selectedBoxType = PanelBoxType.normal;

  void changeTrackerPage() {
    setState(() {
      _selectedBoxType = PanelBoxType.normal;
      _trackerPage = (_trackerPage == 0 ? 1 : 0);
    });
    //
  }

  void changeSelectedBoxType(
    PanelBoxType newType, [
    List<int> newCommander = const [-1, 0],
  ]) {
    setState(() {
      _selectedCommander = newCommander;
      _selectedBoxType = newType;
    });
  }

  // Amount Box - Icon
  String _getIcon() {
    String icon = "health";

    switch (_selectedBoxType) {
      case PanelBoxType.rad:
        icon = "";
        break;
      case PanelBoxType.commander:
        icon = "commander";
        break;
      case PanelBoxType.storm:
        icon = "";
        break;
      case PanelBoxType.energy:
        icon = "energy";
        break;
      case PanelBoxType.experience:
        icon = "experience";
        break;
      case PanelBoxType.poison:
        icon = "poison";
        break;
      case PanelBoxType.commanderTax:
        icon = "commander";
        break;
      default:
        icon = "health";
        break;
    }

    return icon;
  }

// Amount Box - Label
  String _getLabel() {
    String label = "";

    switch (_selectedBoxType) {
      case PanelBoxType.commander:
        label = "Commander Damage";
        if (_selectedCommander[1] == 1) {
          label = "Partner Damage";
        }
        break;
      case PanelBoxType.energy:
        label = "Energy";
        break;
      case PanelBoxType.storm:
        label = "Storm";
        break;
      case PanelBoxType.experience:
        label = "Experience";
        break;
      case PanelBoxType.poison:
        label = "Poison";
        break;
      case PanelBoxType.rad:
        label = "Rad";
        break;
      case PanelBoxType.commanderTax:
        label = "Commander Tax";
        break;
      case PanelBoxType.partnerTax:
        label = "Partner Tax";
        break;
      default:
        label = "";
        break;
    }

    return label;
  }

  List<Widget> _getPanelTrackers(Player player) {
    // General layout for trackers (7 max + Settings)
    // - If more than 7, add a BROWSE button next to Settings
    List<Widget?> list = [
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    ];

    // Add all opponent Commander and Partner if necessary
    if (context.read<SettingNotifier>().showCommanderDamage) {
      for (var opponentIndex = 0;
          opponentIndex < player.opponents.length;
          opponentIndex++) {
        Player opponent = player.opponents[opponentIndex];

        for (var commanderIndex in [0, 1]) {
          // Must have a Partner to add 2 trackers
          if (commanderIndex + 1 > opponent.totalCommanders) {
            continue;
          }
          int widgetIndex = opponentIndex;
          if (commanderIndex > 0) {
            widgetIndex = opponentIndex + (opponentIndex < 4 ? 4 : 1);
          }
          list[widgetIndex] = PressableButton(
            isActive: (_selectedBoxType == PanelBoxType.commander &&
                _selectedCommander[0] == opponentIndex &&
                _selectedCommander[1] == commanderIndex),
            inactiveWidget: opponent.isDead
                ? SvgPicture.asset(
                    "assets/icons/skull.svg",
                    fit: BoxFit.scaleDown,
                    width: 22,
                    color: Colors.white70,
                    semanticsLabel: 'Health',
                  )
                : opponent.totalCommanders == 1
                    ? FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          player.commanderDamages[opponentIndex][commanderIndex]
                              .toString(),
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.headline1!.copyWith(
                                    fontSize: 20,
                                  ),
                        ),
                      )
                    : FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          (commanderIndex == 0 ? "C" : "P") +
                              " " +
                              player.commanderDamages[opponentIndex]
                                      [commanderIndex]
                                  .toString(),
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.headline1!.copyWith(
                                    fontSize: 20,
                                  ),
                        ),
                      ),
            inactiveColor: opponent.getColor(),
            activeColor: Colors.white,
            onToggle: () {
              if (!opponent.isDead) {
                if (_selectedCommander[0] == opponentIndex &&
                    _selectedCommander[1] == commanderIndex) {
                  changeSelectedBoxType(PanelBoxType.normal);
                } else {
                  changeSelectedBoxType(
                      PanelBoxType.commander, [opponentIndex, commanderIndex]);
                }
              }
            },
          );
        }
      }
    }

    // Try to add the SETTINGS, in the BOTTOM LEFT space if available
    // - Else, Pick the first empty spot
    int settingButtonIndex = 3;

    if (list[settingButtonIndex] != null) {
      settingButtonIndex = -1;
      for (int i = list.length - 1; i >= 0; i--) {
        if (list[i] == null) {
          settingButtonIndex = i;
          break;
        }
      }
    }

    if (settingButtonIndex != -1) {
      list[settingButtonIndex] = PressableButton(
        isActive: false,
        inactiveWidget: const Icon(
          Icons.settings,
          color: Colors.white,
        ),
        activeColor: Colors.transparent,
        onToggle: widget.showSettings,
      );
    }

    // Add additional trackers (Poison, Energy, Experience) if there's still enough space
    List<Widget> trackers = [];

    if (context.read<SettingNotifier>().showCommanderTax) {
      trackers.add(
        DynamicPressableButton(
          isActive: _selectedBoxType == PanelBoxType.commanderTax,
          value: player.commanderTax,
          icon: MtgIcons.commander,
          onToggle: () {
            changeSelectedBoxType(
              _selectedBoxType == PanelBoxType.commanderTax
                  ? PanelBoxType.normal
                  : PanelBoxType.commanderTax,
            );
          },
        ),
      );

      if (player.totalCommanders > 1) {
        trackers.add(
          DynamicPressableButton(
            isActive: _selectedBoxType == PanelBoxType.partnerTax,
            value: player.partnerTax,
            icon: MtgIcons.commander,
            onToggle: () {
              changeSelectedBoxType(
                _selectedBoxType == PanelBoxType.partnerTax
                    ? PanelBoxType.normal
                    : PanelBoxType.partnerTax,
              );
            },
          ),
        );
      }
    }

    if (context.read<SettingNotifier>().showPoisonCounter) {
      trackers.add(
        DynamicPressableButton(
          isActive: (_selectedBoxType == PanelBoxType.poison),
          value: player.poison,
          icon: MtgIcons.poison,
          onToggle: () {
            changeSelectedBoxType(
              _selectedBoxType == PanelBoxType.poison
                  ? PanelBoxType.normal
                  : PanelBoxType.poison,
            );
          },
        ),
      );
    }

    if (context.read<SettingNotifier>().showEnergyCounter) {
      trackers.add(
        DynamicPressableButton(
          isActive: (_selectedBoxType == PanelBoxType.energy),
          value: player.energy,
          icon: MtgIcons.energy,
          onToggle: () {
            changeSelectedBoxType(
              _selectedBoxType == PanelBoxType.energy
                  ? PanelBoxType.normal
                  : PanelBoxType.energy,
            );
          },
        ),
      );
    }

    if (context.read<SettingNotifier>().showExperienceCounter) {
      trackers.add(
        DynamicPressableButton(
          isActive: _selectedBoxType == PanelBoxType.experience,
          value: player.experience,
          icon: MtgIcons.experience,
          onToggle: () {
            changeSelectedBoxType(
              _selectedBoxType == PanelBoxType.experience
                  ? PanelBoxType.normal
                  : PanelBoxType.experience,
            );
          },
        ),
      );
    }

    if (context.read<SettingNotifier>().showStormCounter) {
      trackers.add(
        DynamicPressableButton(
          isActive: (_selectedBoxType == PanelBoxType.storm),
          value: player.storm,
          icon: Icons.thunderstorm,
          onToggle: () {
            changeSelectedBoxType(
              _selectedBoxType == PanelBoxType.storm
                  ? PanelBoxType.normal
                  : PanelBoxType.storm,
            );
          },
        ),
      );
    }

    if (context.read<SettingNotifier>().showRadCounter) {
      trackers.add(
        DynamicPressableButton(
          isActive: (_selectedBoxType == PanelBoxType.rad),
          value: player.rad,
          icon: MtgIcons.rad,
          onToggle: () {
            changeSelectedBoxType(
              _selectedBoxType == PanelBoxType.rad
                  ? PanelBoxType.normal
                  : PanelBoxType.rad,
            );
          },
        ),
      );
    }

    int emptySlots = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i] == null) {
        emptySlots++;
      }
    }

    // Add a NEXT button if possible at [7]
    if (trackers.length > emptySlots && list[7] == null) {
      // ...
      list[7] = PressableButton(
        isActive: false,
        inactiveWidget: const Icon(
          Icons.arrow_downward,
          color: Colors.white,
        ),
        activeColor: Colors.transparent,
        onToggle: changeTrackerPage,
      );

      for (int i = 0; i < 8; i++) {
        list.add(null);
      }

      list[7 + 8] = PressableButton(
        isActive: false,
        inactiveWidget: const Icon(
          Icons.arrow_upward,
          color: Colors.white,
        ),
        activeColor: Colors.transparent,
        onToggle: changeTrackerPage,
      );
    }

    // Fit the additionnal trackers in the remaining spaces
    for (int i = 0; i < trackers.length; i++) {
      for (int j = 0; j < list.length; j++) {
        if (list[j] == null) {
          list[j] = trackers[i];
          break;
        }
      }
    }

    // Arrange the list in ROW
    List<Widget> widgets = [];

    int startIndex = (_trackerPage == 0 ? 0 : 8);
    for (int i = startIndex; i < startIndex + 4; i++) {
      List<Widget> content = [];
      for (int j = 0; j < 2; j++) {
        int index = i + (j * 4);
        if (list[index] == null) {
          content.add(
            const PressableButton(
              isVisible: false,
              isActive: false,
              inactiveWidget: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              activeColor: Colors.transparent,
              onToggle: null,
            ),
          );
        } else {
          content.add(list[index]!);
        }
      }
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: content,
        ),
      );
    }

    return widgets;
  }

  // Amount Box - Value
  String _getValue() {
    Player player = Provider.of<Player>(context, listen: false);

    String value = "";

    switch (_selectedBoxType) {
      case PanelBoxType.commander:
        value = player.commanderDamages[_selectedCommander[0]]
                [_selectedCommander[1]]
            .toString();
        break;
      case PanelBoxType.energy:
        value = player.energy.toString();
        break;
      case PanelBoxType.storm:
        value = player.storm.toString();
        break;
      case PanelBoxType.experience:
        value = player.experience.toString();
        break;
      case PanelBoxType.poison:
        value = player.poison.toString();
        break;
      case PanelBoxType.rad:
        value = player.rad.toString();
        break;
      case PanelBoxType.commanderTax:
        value = player.commanderTax.toString();
        break;
      case PanelBoxType.partnerTax:
        value = player.partnerTax.toString();
        break;
      default:
        value = player.health.toString();
        break;
    }

    return value;
  }

  // Amount Box - Saving Value
  bool _setValue(int modifier) {
    Player player = Provider.of<Player>(context, listen: false);

    Player? opponent;

    switch (_selectedBoxType) {
      case PanelBoxType.commander:
        // Do NOT increase Commander Damage over 21
        if (modifier == 1 &&
            player.commanderDamages[_selectedCommander[0]]
                    [_selectedCommander[1]] >=
                21) {
          return false;
        }

        // Set the right opponent for the logs
        opponent = player.opponents[_selectedCommander[0]];

        setState(() {
          player.commanderDamages[_selectedCommander[0]]
              [_selectedCommander[1]] += modifier;

          /* Only change the player health if the settings Auto Apply Commander Damage is selected */
          if (Provider.of<SettingNotifier>(context, listen: false)
              .autoApplyCommanderDamage) {
            player.health += (modifier * -1);
          }

          /* If the Auto Eliminate settings is selected and enough Commander Damage */
          if (Provider.of<SettingNotifier>(context, listen: false)
                  .autoElimitatePlayer &&
              player.commanderDamages[_selectedCommander[0]]
                      [_selectedCommander[1]] >=
                  21) {
            player.isDead = true;
            context.read<Players>().hasChanged();
          }
        });

        break;
      case PanelBoxType.energy:
        player.energy += modifier;
        break;
      case PanelBoxType.rad:
        player.rad += modifier;
        break;
      case PanelBoxType.storm:
        player.storm += modifier;
        break;
      case PanelBoxType.experience:
        player.experience += modifier;
        break;
      case PanelBoxType.poison:
        // Do NOT increate POISON over 10
        if (modifier == 1 && player.poison >= 10) {
          return false;
        }

        player.poison += modifier;
        break;
      case PanelBoxType.commanderTax:
        player.commanderTax += modifier;
        break;
      case PanelBoxType.partnerTax:
        player.partnerTax += modifier;
        break;
      default:
        player.health += modifier;

        /* If the Auto Eliminate settings is selected and enough Damage */
        if (Provider.of<SettingNotifier>(context, listen: false)
                .autoElimitatePlayer &&
            player.health <= 0) {
          player.isDead = true;
          context.read<Players>().hasChanged();
        }
        break;
    }

    context.read<HistoryNotifier>().log(
          player: player,
          type: _selectedBoxType,
          from: int.parse(_getValue()) + (modifier * -1),
          to: modifier,
          opponent: opponent,
          commanderOrPartner: _selectedCommander[1],
        );

    return true;
  }

  bool _showTrackers() {
    // Hide the trackers depending on SimpleMode, more than 6 players, etc.
    if (context.read<SettingNotifier>().isSimpleMode) {
      return false;
    }
    if (context.read<SettingNotifier>().playersNumber > 6) {
      return false;
    }
    // All Around is NOT possible with all the visible trackers
    if (context.read<SettingNotifier>().playersNumber > 4 &&
        context.read<SettingNotifier>().tableLayout == 2) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    Player player = Provider.of<Player>(context, listen: false);

    // Disable previously OPEN other tracker or Commander Damage in SIMPLE mode
    if (context.watch<SettingNotifier>().isSimpleMode &&
        _selectedBoxType != PanelBoxType.normal) {
      changeSelectedBoxType(PanelBoxType.normal);
    }

    // If the Partner is selected, but not available anymore, reset it
    if (_selectedBoxType == PanelBoxType.commander &&
        _selectedCommander[1] == 1 &&
        player.opponents[_selectedCommander[0]].totalCommanders == 1) {
      changeSelectedBoxType(PanelBoxType.normal);
    }

    // If a Commander Damage of a DEAD player is selected, reset it
    if (_selectedCommander[0] != -1 &&
        player.opponents[_selectedCommander[0]].isDead) {
      changeSelectedBoxType(PanelBoxType.normal);
    }

    // Remove dynamic SELECTED trackers, not available anymore
    Map<PanelBoxType, bool> trackers = {
      PanelBoxType.commanderTax:
          context.watch<SettingNotifier>().showCommanderTax,
      PanelBoxType.energy: context.watch<SettingNotifier>().showEnergyCounter,
      PanelBoxType.experience:
          context.watch<SettingNotifier>().showExperienceCounter,
      PanelBoxType.poison: context.watch<SettingNotifier>().showPoisonCounter,
      PanelBoxType.storm: context.watch<SettingNotifier>().showStormCounter,
      PanelBoxType.rad: context.watch<SettingNotifier>().showRadCounter,
    };

    if (_selectedBoxType != PanelBoxType.normal &&
        trackers.containsKey(_selectedBoxType) &&
        !trackers[_selectedBoxType]!) {
      changeSelectedBoxType(PanelBoxType.normal);
    }

    // Close commander Window when they are open and not available anymore
    if (!context.watch<SettingNotifier>().showCommanderDamage &&
        _selectedBoxType == PanelBoxType.commander) {
      changeSelectedBoxType(PanelBoxType.normal);
    }

    String amountBoxKey = _selectedBoxType.toString();
    if (_selectedBoxType == PanelBoxType.commander) {
      amountBoxKey = "commander-" +
          _selectedCommander[0].toString() +
          "-" +
          _selectedCommander[1].toString();
    }

    return Row(
      children: [
        // Commander Damages, Settings and other Trackers
        if (_showTrackers())
          Expanded(
            flex: context.read<SettingNotifier>().playersNumber <= 4 ? 1 : 2,
            child: Container(
              padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _getPanelTrackers(player),
              ),
            ),
          ),
        // Amount Boxes
        Expanded(
          flex: context.read<SettingNotifier>().playersNumber <= 4 ? 2 : 3,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: AmountBox(
              onAutoClose: _selectedBoxType == PanelBoxType.commander
                  ? () {
                      if (context.read<SettingNotifier>().autoCloseTracker) {
                        changeSelectedBoxType(PanelBoxType.normal);
                      }
                    }
                  : null,
              key: ValueKey<String>(amountBoxKey),
              getIcon: _getIcon,
              getLabel: _getLabel,
              getValue: _getValue,
              setValue: _setValue,
            ),
          ),
        ),
      ],
    );
  }
}
