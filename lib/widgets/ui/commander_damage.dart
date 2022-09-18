import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mtgtracker/providers/player.dart';

class CommanderDamage extends StatelessWidget {
  final Player opponent;
  final Player player;
  final void Function(int, int) onSelected;

  const CommanderDamage({
    Key? key,
    required this.opponent,
    required this.player,
    required this.onSelected,
  }) : super(key: key);

  List<Widget> _getCommanders(BuildContext context) {
    List<Widget> commanders = [];
    print(opponent.data['totalCommanders']);
    for (int i = 0; i < opponent.data['totalCommanders']!; i++) {
      commanders.add(
        Container(
          color: opponent.getColor(context),
          child: Material(
            key: ValueKey(i.toString()),
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                onSelected(int.parse(opponent.id), i);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/commander.svg",
                      width: 30,
                      height: 30,
                      fit: BoxFit.scaleDown,
                      color: const Color.fromRGBO(0, 0, 0, 0),
                      semanticsLabel: 'Commander',
                    ),
                    Text(
                      player.commander[int.parse(opponent.id)][i].toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      if (i < opponent.data['totalCommanders']! - 1) {
        commanders.add(
          const Spacer(),
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
