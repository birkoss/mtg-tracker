import 'package:async/async.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/player.dart';

import '../../widgets/ui/amount/button.dart';
import '../../widgets/ui/amount/text.dart';
import '../../widgets/boxes/player.dart';

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
      default:
        return 'health';
    }
  }
}

class AmountBox extends StatefulWidget {
  final PlayerBoxView boxView;

  final Player? selectedPlayer;

  final Function onSwitchCommander;
  final Function onChangeType;

  const AmountBox({
    Key? key,
    required this.boxView,
    required this.selectedPlayer,
    required this.onSwitchCommander,
    required this.onChangeType,
  }) : super(key: key);

  @override
  _AmountBox createState() => _AmountBox();
}

class _AmountBox extends State<AmountBox> {
  AmountBoxType _type = AmountBoxType.normal;

  int _amountChanges = 0;
  late RestartableTimer _timerAmountChanges;

  void updateAmount(int value) {
    _timerAmountChanges.reset();
    setState(() {
      _amountChanges += value;
    });
  }

  double getAmountFontSize() {
    double fontSize = 50; // 80

    // switch (widget.size) {
    //   case TrackerSize.small:
    //     fontSize = 30;
    //     break;
    //   case TrackerSize.medium:
    //     fontSize = 50;
    //     break;
    //   case TrackerSize.large:
    //     fontSize = 80;
    //     break;
    // }

    return fontSize;
  }

  @override
  void initState() {
    super.initState();

    _timerAmountChanges = RestartableTimer(
      const Duration(seconds: 2),
      () {
        setState(() {
          _amountChanges = 0;
        });
      },
    );
  }

  @override
  void dispose() {
    _timerAmountChanges.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var player = Provider.of<Player>(context, listen: false);

    String _getValue() {
      if (widget.boxView == PlayerBoxView.commander) {
        return player.commander[int.parse(widget.selectedPlayer!.id)]
            .toString();
      }
      return player.data[_type.dataIndex].toString();
    }

    void _changeValue(int modifier) {
      updateAmount(modifier);

      if (widget.boxView == PlayerBoxView.commander) {
        player.commander[int.parse(widget.selectedPlayer!.id)] =
            player.commander[int.parse(widget.selectedPlayer!.id)] + modifier;
      } else {
        player.data[_type.dataIndex] = player.data[_type.dataIndex]! + modifier;
      }
    }

    return Container(
      color: player.color,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: AmountButton(
              label: "-",
              onPress: () {
                _changeValue(-1);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AmountText(
                    amount: _amountChanges,
                  ),
                  Text(
                    _getValue(),
                    style: TextStyle(
                      fontSize: getAmountFontSize(),
                      color: Colors.white,
                    ),
                  ),
                  if (widget.boxView == PlayerBoxView.commander)
                    const SizedBox(
                      height: 20,
                    ),
                  if (widget.boxView == PlayerBoxView.normal)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: Material(
                            color: Colors.transparent,
                            child: IconButton(
                              icon: SvgPicture.asset(
                                "assets/icons/commander.svg",
                                color: Colors.white,
                                semanticsLabel: 'Commander',
                              ),
                              onPressed: () {
                                widget.onSwitchCommander(player);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: Material(
                            color: Colors.transparent,
                            child: IconButton(
                              icon: SvgPicture.asset(
                                "assets/icons/" + _type.dataIndex + ".svg",
                                color: Colors.white,
                                semanticsLabel: 'Commander',
                              ),
                              onPressed: () {
                                print("@TODO : CHANGING TYPE...");
                                setState(() {
                                  if (_type == AmountBoxType.normal) {
                                    _type = AmountBoxType.poison;
                                  } else {
                                    _type = AmountBoxType.normal;
                                  }
                                });
                                widget.onChangeType();
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: AmountButton(
              label: "+",
              onPress: () {
                _changeValue(1);
              },
            ),
          ),
        ],
      ),
    );
  }
}
