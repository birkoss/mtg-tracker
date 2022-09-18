import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mtgtracker/providers/player.dart';

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

    for (int i = 0; i < opponent.data['totalCommanders']!; i++) {
      commanders.add(
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: opponent.getColor(context),
              border: Border.all(
                width: 3,
                color: isSelected(int.parse(opponent.id), i)
                    ? Colors.white
                    : opponent.getColor(context),
              ),
            ),
            child: Material(
              key: ValueKey(i.toString()),
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  onSelected(int.parse(opponent.id), i);
                },
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    isSelected(int.parse(opponent.id), i)
                        ? "X"
                        : player.commander[int.parse(opponent.id)][i]
                            .toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      if (i < opponent.data['totalCommanders']! - 1) {
        commanders.add(
          const SizedBox(width: 6),
        );
      }
    }

    return commanders;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _getCommanders(context),
    );
  }
}
