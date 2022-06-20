import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  final Function onToggleCommanderView;

  const AmountDataBox({
    Key? key,
    required this.onToggleCommanderView,
  }) : super(key: key);

  @override
  State<AmountDataBox> createState() => _AmountDataBoxState();
}

class _AmountDataBoxState extends State<AmountDataBox> {
  AmountBoxType _type = AmountBoxType.normal;
  final List<AmountBoxType> _types = [
    AmountBoxType.normal,
    AmountBoxType.poison,
    AmountBoxType.energy,
    AmountBoxType.experience,
  ];

  @override
  Widget build(BuildContext context) {
    Player player = Provider.of<Player>(context, listen: false);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SvgPicture.asset(
            "assets/icons/" + _type.dataIndex + ".svg",
            fit: BoxFit.scaleDown,
            color: Colors.white10,
            semanticsLabel: 'Commander',
          ),
        ),
        AmountBox(
          getValue: () {
            return player.data[_type.dataIndex].toString();
          },
          setValue: (int modifier) {
            player.data[_type.dataIndex] =
                player.data[_type.dataIndex]! + modifier;

            return true;
          },
          onPress: () {
            setState(() {
              int index = _types.indexOf(_type) + 1;
              if (index >= _types.length) {
                index = 0;
              }
              _type = _types.elementAt(index);
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/commander.svg",
                    height: 30,
                    fit: BoxFit.scaleDown,
                    color: Colors.white70,
                    semanticsLabel: 'Commander',
                  ),
                  onPressed: () {
                    widget.onToggleCommanderView(player);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
