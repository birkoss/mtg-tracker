import 'package:async/async.dart';
import 'package:flutter/material.dart';

import '../widgets/amount_changes.dart';
import '../widgets/button_updater.dart';

enum SelectedPlayerSize { small, medium, large }

class SelectedPlayer extends StatefulWidget {
  final int rotationQuarterTurns;
  final Color backgroundColor;
  final SelectedPlayerSize size;
  final Function onPressOptions;

  const SelectedPlayer({
    Key? key,
    required this.rotationQuarterTurns,
    required this.backgroundColor,
    required this.size,
    required this.onPressOptions,
  }) : super(key: key);

  @override
  _SelectedPlayerState createState() => _SelectedPlayerState();
}

class _SelectedPlayerState extends State<SelectedPlayer> {
  int health = 0;

  int healthChanges = 0;
  late RestartableTimer _timerHealthChanges;

  void updateHealth(int value) {
    _timerHealthChanges.reset();
    setState(() {
      health += value;
      healthChanges += value;
    });
  }

  double getAmountFontSize() {
    double fontSize = 80;

    switch (widget.size) {
      case SelectedPlayerSize.small:
        fontSize = 40;
        break;
      case SelectedPlayerSize.medium:
        fontSize = 50;
        break;
      case SelectedPlayerSize.large:
        fontSize = 80;
        break;
    }

    return fontSize;
  }

  @override
  void initState() {
    super.initState();

    _timerHealthChanges = RestartableTimer(
      const Duration(seconds: 2),
      () {
        setState(() {
          healthChanges = 0;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RotatedBox(
        quarterTurns: widget.rotationQuarterTurns,
        child: Container(
          color: widget.backgroundColor,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: ButtonUpdater(
                  label: "-",
                  onPress: () {
                    updateHealth(-1);
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
                        amount: healthChanges,
                      ),
                      Text(
                        health.toString(),
                        style: TextStyle(
                          fontSize: getAmountFontSize(),
                          color: Colors.white,
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white70,
                          ),
                          onPressed: () {},
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
                    updateHealth(1);
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
