import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/player.dart';

import '../widgets/amount_changes.dart';
import '../widgets/button_updater.dart';
import '../widgets/tracker.dart';

class TrackerCommander extends StatefulWidget {
  final int rotation;
  final TrackerSize size;
  final Function onPressOptions;
  final int currentPlayer;

  const TrackerCommander({
    Key? key,
    required this.rotation,
    required this.size,
    required this.onPressOptions,
    required this.currentPlayer,
  }) : super(key: key);

  @override
  _TrackerCommanderState createState() => _TrackerCommanderState();
}

class _TrackerCommanderState extends State<TrackerCommander> {
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
        fontSize = 40;
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
                    player.commander[widget.currentPlayer]--;
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
                        player.commander[widget.currentPlayer].toString(),
                        style: TextStyle(
                          fontSize: getAmountFontSize(),
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "CMD Damage",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
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
                    player.commander[widget.currentPlayer]++;
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
