import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/player.dart';

import '../../widgets/amount_changes.dart';
import '../../widgets/button_updater.dart';
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

  final Function onSwitchCommander;
  final Function onChangeType;

  const AmountBox({
    Key? key,
    required this.boxView,
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
        return "CMD...";
      }
      return player.data[_type.dataIndex].toString();
    }

    void _changeValue(int modifier) {
      if (widget.boxView == PlayerBoxView.commander) {
        //return "CMD...";
      }
      //player.data[_type.dataIndex] += modifier;
      player.data[_type.dataIndex] = player.data[_type.dataIndex]! + modifier;
    }

    return Container(
      color: player.color,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: ButtonUpdater(
              label: "-",
              onPress: () {
                _changeValue(-1);

                updateAmount(-1);
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
                  AmountChanges(
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
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: IconButton(
                            iconSize:
                                22, //widget.size == TrackerSize.small ? 22 : 32,
                            icon: const Icon(
                              Icons.filter_alt,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              widget.onSwitchCommander(player);
                            },
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: IconButton(
                            iconSize:
                                22, //widget.size == TrackerSize.small ? 22 : 32,
                            icon: const Icon(
                              Icons.heart_broken,
                              color: Colors.white70,
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
                        )
                      ],
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ButtonUpdater(
              label: "+",
              onPress: () {
                // if (widget.type == PlayerBoxType.normal) {
                _changeValue(1);
                //} else {
                //player.poison++;
                //}
                updateAmount(1);
              },
            ),
          ),
        ],
      ),
    );
  }
}