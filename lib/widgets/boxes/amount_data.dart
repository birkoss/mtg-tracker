import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/player.dart';
import '../../providers/setting.dart';

import '../../widgets/boxes/amount.dart';
import '../../widgets/mtgicons.dart';
import '../../widgets/pressable_button.dart';
import '../../widgets/ui/commander_damage.dart';

// What are we modifying in the Amount Box
enum AmountBoxType {
  normal,
  poison,
  energy,
  experience,
}

extension AmountBoxTypeExtension on AmountBoxType {
  String get dataIndex {
    switch (this) {
      case AmountBoxType.normal:
        return 'health';
      case AmountBoxType.poison:
        return 'poison';
      case AmountBoxType.energy:
        return 'energy';
      case AmountBoxType.experience:
        return 'experience';
      default:
        return 'health';
    }
  }
}

class AmountDataBox extends StatefulWidget {
  final VoidCallback showSettings;

  const AmountDataBox({
    Key? key,
    required this.showSettings,
  }) : super(key: key);

  @override
  State<AmountDataBox> createState() => _AmountDataBoxState();
}

class _AmountDataBoxState extends State<AmountDataBox> {
  // [X, 0] for commander, [X, 1] for the partner
  List<int> selectedOpponentCommander = [-1, 0];

  AmountBoxType _type = AmountBoxType.normal;

  List<Widget> _getOpponentsCommanderDamages(Player player) {
    List<Widget> widgets = [];

    for (var opponent in player.opponents) {
      widgets.add(
        CommanderDamage(
            isSelected: (currentOpponent, currentCommander) {
              return (selectedOpponentCommander[0] == currentOpponent &&
                  selectedOpponentCommander[1] == currentCommander);
            },
            player: player,
            opponent: opponent,
            onSelected: (selectedOpponent, selectedCommander) {
              setState(() {
                _type = AmountBoxType.normal;

                if (selectedOpponentCommander[0] == selectedOpponent &&
                    selectedOpponentCommander[1] == selectedCommander) {
                  selectedOpponentCommander[0] = -1;
                  selectedOpponentCommander[1] = 0;
                } else {
                  selectedOpponentCommander[0] = selectedOpponent;
                  selectedOpponentCommander[1] = selectedCommander;
                }
              });
            }),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Player player = Provider.of<Player>(context, listen: false);

    // If a CommanderDamage of a dead player is selected, reset it
    if (selectedOpponentCommander[0] != -1) {
      if (player.opponents[selectedOpponentCommander[0]].isDead) {
        setState(() {
          selectedOpponentCommander = [-1, 0];
        });
      }
    }

    String amountBoxKey = _type.toString();
    if (selectedOpponentCommander[0] != -1) {
      amountBoxKey = "commander-" +
          selectedOpponentCommander[0].toString() +
          "-" +
          selectedOpponentCommander[1].toString();
    }

    return Row(
      children: [
        // Commander Damages, Settings and Poison
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ..._getOpponentsCommanderDamages(player),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PressableButton(
                      isVisible: true,
                      isActive: false,
                      inactiveWidget: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      inactiveColor: Colors.transparent,
                      activeColor: Colors.transparent,
                      onToggle: () {
                        widget.showSettings();
                      },
                    ),
                    PressableButton(
                      isVisible: true,
                      isActive: (_type == AmountBoxType.poison),
                      inactiveWidget: player.data['poison']! == 0
                          ? const Icon(
                              MtgIcons.poison,
                              color: Colors.white,
                            )
                          : Text(
                              player.data['poison']!.toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(fontSize: 20),
                            ),
                      inactiveColor: Colors.transparent,
                      activeColor: Colors.white,
                      onToggle: () {
                        setState(() {
                          selectedOpponentCommander = [-1, 0];
                          _type = _type == AmountBoxType.normal
                              ? AmountBoxType.poison
                              : AmountBoxType.normal;
                        });
                      },
                    ),
                  ],
                )
              ],
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
              getIcon: () {
                return selectedOpponentCommander[0] != -1
                    ? "commander"
                    : _type == AmountBoxType.normal
                        ? "health"
                        : "poison";
              },
              getValue: () {
                if (selectedOpponentCommander[0] != -1) {
                  return player.commanderDamages[selectedOpponentCommander[0]]
                          [selectedOpponentCommander[1]]
                      .toString();
                }
                return player.data[_type.dataIndex].toString();
              },
              setValue: (int modifier) {
                if (selectedOpponentCommander[0] != -1) {
                  // Do NOT increase Commander Damage over 21
                  if (modifier == 1 &&
                      player.commanderDamages[selectedOpponentCommander[0]]
                              [selectedOpponentCommander[1]] >=
                          21) {
                    return false;
                  }

                  setState(() {
                    player.commanderDamages[selectedOpponentCommander[0]]
                        [selectedOpponentCommander[1]] += modifier;

                    /* Only change the player health if the settings Auto Apply Commander Damage is selected */
                    if (Provider.of<SettingNotifier>(context, listen: false)
                        .autoApplyCommanderDamage) {
                      player.data['health'] =
                          player.data['health']! + (modifier * -1);

                      // Never let HEALTH lower than 0
                      player.data['health'] = max(0, player.data['health']!);
                    }
                  });
                } else {
                  // Do NOT increate POISON over 10
                  if (modifier == 1 &&
                      _type.dataIndex == "poison" &&
                      player.data[_type.dataIndex]! >= 10) {
                    return false;
                  }
                  player.data[_type.dataIndex] =
                      player.data[_type.dataIndex]! + modifier;
                }

                return true;
              },
            ),
          ),
        ),
      ],
    );
  }
}
