import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mtgtracker/providers/player.dart';
import 'package:mtgtracker/widgets/pressable_button.dart';

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

    for (int i = 0; i < 2; i++) {
      commanders.add(
        PressableButton(
          isVisible: (i + 1 <= opponent.data['totalCommanders']!),
          isActive: isSelected(int.parse(opponent.id), i),
          inactiveWidget: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              player.commander[int.parse(opponent.id)][i].toString(),
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.headline1!.copyWith(fontSize: 20),
            ),
          ),
          inactiveColor: opponent.getColor(context),
          activeColor: Colors.white,
          onToggle: () {
            onSelected(int.parse(opponent.id), i);
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
