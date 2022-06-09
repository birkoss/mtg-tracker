import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/player.dart';

import '../widgets/amount_changes.dart';
import '../widgets/button_updater.dart';

enum TrackerSize { small, medium, large }

enum TrackerType { normal, poison, commander }

class AmountContainer extends StatefulWidget {
  final int rotation;
  final TrackerSize size;
  final TrackerType type;
  final Function onPressOptions;

  const AmountContainer({
    Key? key,
    required this.rotation,
    required this.size,
    required this.type,
    required this.onPressOptions,
  }) : super(key: key);

  @override
  _AmountContainer createState() => _AmountContainer();
}

class _AmountContainer extends State<AmountContainer> {
  int _amountChanges = 0;
  late RestartableTimer _timerAmountChanges;

  void updateAmount(int value) {
    _timerAmountChanges.reset();
    setState(() {
      _amountChanges += value;
    });
  }

  double getAmountFontSize() {
    double fontSize = 80;

    switch (widget.size) {
      case TrackerSize.small:
        fontSize = 30;
        break;
      case TrackerSize.medium:
        fontSize = 50;
        break;
      case TrackerSize.large:
        fontSize = 80;
        break;
    }

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
    return Expanded(
      child: RotatedBox(
        quarterTurns: widget.rotation,
        child: Container(
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
                    if (widget.type == TrackerType.normal) {
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
                        widget.type == TrackerType.normal
                            ? player.health.toString()
                            : player.poison.toString(),
                        style: TextStyle(
                          fontSize: getAmountFontSize(),
                          color: Colors.white,
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: IconButton(
                          iconSize: widget.size == TrackerSize.small ? 22 : 32,
                          icon: Icon(
                            widget.type == TrackerType.normal
                                ? Icons.filter_alt
                                : Icons.close,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            widget.onPressOptions(player);
                          },
                        ),
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
                    if (widget.type == TrackerType.normal) {
                      player.health++;
                    } else {
                      player.poison++;
                    }
                    updateAmount(1);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
