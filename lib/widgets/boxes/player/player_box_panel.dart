import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mtgtracker/providers/history.dart';
import 'package:mtgtracker/providers/players.dart';
import 'package:provider/provider.dart';

import '../../../providers/player.dart';
import '../../../providers/setting.dart';

import '../amount.dart';
import '../../pressable_button.dart';
import '../../../widgets/mtgicons.dart';

// What are we modifying in the Panel
enum PanelBoxType {
  commander,
  normal,
  poison,
  energy,
  experience,
  commanderTax,
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
  // [0] = Opponent, [1] = Commander,Partner (0,1)
  List<int> _selectedCommander = [-1, 0];

  PanelBoxType _selectedBoxType = PanelBoxType.normal;

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
      case PanelBoxType.commander:
        icon = "commander";
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
        break;
      case PanelBoxType.energy:
        label = "Energy";
        break;
      case PanelBoxType.experience:
        label = "Experience";
        break;
      case PanelBoxType.poison:
        label = "Poison";
        break;
      case PanelBoxType.commanderTax:
        label = "Commander Tax";
        break;
      default:
        label = "";
        break;
    }

    return label;
  }

  List<Widget> _getPanelTrackers(Player player) {
    // General layout for trackers (7 max + Settings)
    List<Widget?> list = [
      null,
      null,
      null,
      PressableButton(
        isActive: false,
        inactiveWidget: const Icon(
          Icons.settings,
          color: Colors.white,
        ),
        activeColor: Colors.transparent,
        onToggle: widget.showSettings,
      ),
      null,
      null,
      null,
      null,
    ];

    // Add all opponent Commander and Partner if necessary
    for (var opponentIndex = 0;
        opponentIndex < player.opponents.length;
        opponentIndex++) {
      Player opponent = player.opponents[opponentIndex];

      for (var commanderIndex in [0, 1]) {
        // Must have a Partner to add 2 trackers
        if (commanderIndex + 1 > opponent.totalCommanders) {
          continue;
        }
        list[commanderIndex == 0 ? opponentIndex : opponentIndex + 4] =
            PressableButton(
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
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    player.commanderDamages[opponentIndex][commanderIndex]
                        .toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline1!.copyWith(
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

    // Add additional trackers (Poison, Energy, Experience) if there's still enough space
    List<Widget> trackers = [];
    if (context.read<SettingNotifier>().showPoisonCounter) {
      trackers.add(
        PressableButton(
          isVisible: true,
          isActive: (_selectedBoxType == PanelBoxType.poison),
          inactiveWidget: player.poison == 0
              ? const Icon(
                  MtgIcons.poison,
                  color: Colors.white,
                )
              : Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    const Icon(
                      MtgIcons.poison,
                      size: 16,
                      color: Colors.white30,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        player.poison.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                ),
          activeColor: Colors.white,
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
        PressableButton(
          isVisible: true,
          isActive: (_selectedBoxType == PanelBoxType.energy),
          inactiveWidget: player.energy == 0
              ? const Icon(
                  MtgIcons.energy,
                  color: Colors.white,
                )
              : Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    const Icon(
                      MtgIcons.energy,
                      size: 16,
                      color: Colors.white30,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        player.energy.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                ),
          activeColor: Colors.white,
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
        PressableButton(
          isVisible: true,
          isActive: (_selectedBoxType == PanelBoxType.experience),
          inactiveWidget: player.experience == 0
              ? const Icon(
                  MtgIcons.experience,
                  color: Colors.white,
                )
              : Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    const Icon(
                      MtgIcons.experience,
                      size: 16,
                      color: Colors.white30,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        player.experience.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                ),
          activeColor: Colors.white,
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

    if (context.read<SettingNotifier>().showCommanderTax) {
      trackers.add(
        PressableButton(
          isVisible: true,
          isActive: (_selectedBoxType == PanelBoxType.commanderTax),
          inactiveWidget: player.commanderTax == 0
              ? const Icon(
                  MtgIcons.commander,
                  color: Colors.white,
                )
              : Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    const Icon(
                      MtgIcons.commander,
                      size: 16,
                      color: Colors.white30,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        player.commanderTax.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                ),
          activeColor: Colors.white,
          onToggle: () {
            changeSelectedBoxType(
              _selectedBoxType == PanelBoxType.commanderTax
                  ? PanelBoxType.normal
                  : PanelBoxType.commanderTax,
            );
          },
        ),
      );
    }

    for (int i = 0; i < trackers.length; i++) {
      for (int j = list.length - 1; j >= 0; j--) {
        if (list[j] == null) {
          list[j] = trackers[i];
          break;
        }
      }
    }

    // Arrange the list in ROW
    List<Widget> widgets = [];

    for (int i = 0; i < list.length / 2; i++) {
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
      case PanelBoxType.experience:
        value = player.experience.toString();
        break;
      case PanelBoxType.poison:
        value = player.poison.toString();
        break;
      case PanelBoxType.commanderTax:
        value = player.commanderTax.toString();
        break;
      default:
        value = player.health.toString();
        break;
    }

    return value;
  }

  // Amount Box - Saving Value
  bool _setValue(int modifier) {
    //HistoryNotifier

    Player player = Provider.of<Player>(context, listen: false);

    context.read<HistoryNotifier>().log(
          player: player,
          type: _selectedBoxType,
          from: int.parse(_getValue()),
          to: modifier,
        );

    switch (_selectedBoxType) {
      case PanelBoxType.commander:
        // Do NOT increase Commander Damage over 21
        if (modifier == 1 &&
            player.commanderDamages[_selectedCommander[0]]
                    [_selectedCommander[1]] >=
                21) {
          return false;
        }

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
    };

    if (_selectedBoxType != PanelBoxType.normal &&
        trackers.containsKey(_selectedBoxType) &&
        !trackers[_selectedBoxType]!) {
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
        if (!context.read<SettingNotifier>().isSimpleMode)
          Expanded(
            flex: 1,
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
          flex: 2,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: AmountBox(
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
