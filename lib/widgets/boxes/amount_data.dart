import 'package:flutter/material.dart';
import 'package:mtgtracker/widgets/mtgicons.dart';
import 'package:mtgtracker/widgets/pressable_button.dart';
import 'package:mtgtracker/widgets/ui/commander_damage.dart';
import 'package:provider/provider.dart';

import '../../providers/player.dart';
import '../../widgets/boxes/amount.dart';

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
  final List<Player> opponents;
  final VoidCallback showSettings;

  const AmountDataBox({
    Key? key,
    required this.showSettings,
    required this.opponents,
  }) : super(key: key);

  @override
  State<AmountDataBox> createState() => _AmountDataBoxState();
}

class _AmountDataBoxState extends State<AmountDataBox> {
  // [X, 0] for commander, [X, 1] for the partner
  List<int> selectedOpponentCommander = [-1, 0];

  AmountBoxType _type = AmountBoxType.normal;
  final List<AmountBoxType> _types = [
    AmountBoxType.normal,
    AmountBoxType.poison,
    AmountBoxType.energy,
    AmountBoxType.experience,
  ];

  List<Widget> _getOpponents(BuildContext context, Player player) {
    List<Widget> widgets = [];

    for (var opponent in widget.opponents) {
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

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ..._getOpponents(context, player),
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
        Expanded(
          flex: 2,
          child: AmountBox(
            getIcon: () {
              return selectedOpponentCommander[0] != -1
                  ? "commander"
                  : _type == AmountBoxType.normal
                      ? "health"
                      : "poison";
            },
            getValue: () {
              if (selectedOpponentCommander[0] != -1) {
                return player.commander[selectedOpponentCommander[0]]
                        [selectedOpponentCommander[1]]
                    .toString();
              }
              return player.data[_type.dataIndex].toString();
            },
            setValue: (int modifier) {
              if (selectedOpponentCommander[0] != -1) {
                setState(() {
                  player.commander[selectedOpponentCommander[0]]
                      [selectedOpponentCommander[1]] += modifier;
                });
              } else {
                player.data[_type.dataIndex] =
                    player.data[_type.dataIndex]! + modifier;
              }

              return true;
            },
          ),
        ),
      ],
    );
  }
}
