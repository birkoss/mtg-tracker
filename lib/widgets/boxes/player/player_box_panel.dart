import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/player.dart';
import '../../../providers/setting.dart';

import '../amount.dart';
import '../../mtgicons.dart';
import '../../pressable_button.dart';
import '../../ui/commander_damage.dart';

// What are we modifying in the Panel
enum PanelBoxType {
  commander,
  normal,
  poison,
  energy,
  experience,
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

  List<Widget> _getOpponentsCommanderDamages(Player player) {
    List<Widget> widgets = [];

    for (var opponent in player.opponents) {
      widgets.add(
        CommanderDamage(
          isSelected: (opponent, commander) {
            return (_selectedBoxType == PanelBoxType.commander &&
                _selectedCommander[0] == opponent &&
                _selectedCommander[1] == commander);
          },
          player: player,
          opponent: opponent,
          onSelected: (opponent, commander) {
            setState(() {
              if (_selectedCommander[0] == opponent &&
                  _selectedCommander[1] == commander) {
                _selectedBoxType = PanelBoxType.normal;
                _selectedCommander[0] = -1;
                _selectedCommander[1] = 0;
              } else {
                _selectedBoxType = PanelBoxType.commander;
                _selectedCommander[0] = opponent;
                _selectedCommander[1] = commander;
              }
            });
          },
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Player player = Provider.of<Player>(context, listen: false);

    // If a CommanderDamage of a dead player is selected, reset it
    if (_selectedCommander[0] != -1) {
      if (player.opponents[_selectedCommander[0]].isDead) {
        setState(() {
          _selectedCommander = [-1, 0];
        });
      }
    }

    String amountBoxKey = _selectedBoxType.toString();
    if (_selectedCommander[0] != -1) {
      amountBoxKey = "commander-" +
          _selectedCommander[0].toString() +
          "-" +
          _selectedCommander[1].toString();
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
                      isActive: false,
                      inactiveWidget: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      activeColor: Colors.transparent,
                      onToggle: widget.showSettings,
                    ),
                    PressableButton(
                      isVisible: true,
                      isActive: (_selectedBoxType == PanelBoxType.poison),
                      inactiveWidget: player.poison == 0
                          ? const Icon(
                              MtgIcons.poison,
                              color: Colors.white,
                            )
                          : Text(
                              player.poison.toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(fontSize: 20),
                            ),
                      activeColor: Colors.white,
                      onToggle: () {
                        setState(() {
                          _selectedCommander = [-1, 0];
                          _selectedBoxType =
                              _selectedBoxType == PanelBoxType.poison
                                  ? PanelBoxType.normal
                                  : PanelBoxType.poison;
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
                return _selectedCommander[0] != -1
                    ? "commander"
                    : _selectedBoxType == PanelBoxType.normal
                        ? "health"
                        : "poison";
              },
              getValue: () {
                if (_selectedCommander[0] != -1) {
                  return player.commanderDamages[_selectedCommander[0]]
                          [_selectedCommander[1]]
                      .toString();
                }
                if (_selectedBoxType == PanelBoxType.normal) {
                  return player.health.toString();
                } else if (_selectedBoxType == PanelBoxType.poison) {
                  return player.poison.toString();
                }
              },
              setValue: (int modifier) {
                if (_selectedCommander[0] != -1) {
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
                  });
                } else {
                  if (_selectedBoxType == PanelBoxType.normal) {
                    player.health += modifier;
                  } else if (_selectedBoxType == PanelBoxType.poison) {
                    // Do NOT increate POISON over 10
                    if (modifier == 1 && player.poison >= 10) {
                      return false;
                    }

                    player.poison += modifier;

                    /* Only change the player health if the settings Auto Apply Poison Damage is selected */
                    if (Provider.of<SettingNotifier>(context, listen: false)
                        .autoApplyPoisonDamage) {
                      player.health += (modifier * -1);
                    }
                  }
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
