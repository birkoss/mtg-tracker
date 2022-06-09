import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/player.dart';

import '../../widgets/amount_changes.dart';
import '../../widgets/button_updater.dart';
import '../../widgets/boxes/player.dart';

class AmountBox extends StatefulWidget {
  final PlayerBoxType boxType;

  final Function onSwitchCommander;
  final Function onChangeType;

  const AmountBox({
    Key? key,
    required this.boxType,
    required this.onSwitchCommander,
    required this.onChangeType,
  }) : super(key: key);

  @override
  _AmountBox createState() => _AmountBox();
}

class _AmountBox extends State<AmountBox> {
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
                if (widget.boxType == PlayerBoxType.normal) {
                  player.health--;
                } else {
                  player.poison--;
                }
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
                    widget.boxType == PlayerBoxType.normal
                        ? player.health.toString()
                        : player.poison.toString(),
                    style: TextStyle(
                      fontSize: getAmountFontSize(),
                      color: Colors.white,
                    ),
                  ),
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
                player.health++;
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
