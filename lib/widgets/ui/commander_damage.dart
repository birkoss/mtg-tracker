import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../providers/player.dart';

import '../../widgets/pressable_button.dart';

class CommanderDamage extends StatelessWidget {
  final Player opponent;
  final Player player;
  final void Function(int, int) onSelected;
  final bool Function(int, int) isSelected;

  const CommanderDamage({
    Key? key,
    required this.opponent,
    required this.player,
    required this.onSelected,
    required this.isSelected,
  }) : super(key: key);

  List<Widget> _getCommanders(BuildContext context) {
    List<Widget> commanders = [];

    int opponentIndex = player.opponents.indexOf(opponent);

    for (int i = 0; i < 2; i++) {
      commanders.add(
        PressableButton(
          isVisible: (i + 1 <= opponent.totalCommanders),
          isActive: isSelected(opponentIndex, i),
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
                    player.commanderDamages[opponentIndex][i].toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 20),
                  ),
                ),
          inactiveColor: opponent.getColor(),
          activeColor: Colors.white,
          onToggle: () {
            if (!opponent.isDead) {
              onSelected(opponentIndex, i);
            }
          },
        ),
      );
    }

    return commanders;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _getCommanders(context),
    );
  }
}
