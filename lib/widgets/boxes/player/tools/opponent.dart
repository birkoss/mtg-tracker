import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/player.dart';
import '../../../../providers/players.dart';
import '../../../../providers/setting.dart';

class PlayerBoxSettingsToolsOpponent extends StatefulWidget {
  final void Function()? onBackClicked;

  const PlayerBoxSettingsToolsOpponent({
    Key? key,
    this.onBackClicked,
  }) : super(key: key);

  @override
  State<PlayerBoxSettingsToolsOpponent> createState() =>
      _PlayerBoxSettingsToolsOpponentState();
}

class _PlayerBoxSettingsToolsOpponentState
    extends State<PlayerBoxSettingsToolsOpponent> {
  int _opponent = -1;

  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() {
        _isVisible = true;
      }),
    );

    waitForFirstPick();
  }

  void waitForFirstPick() async {
    await Future.delayed(
      const Duration(milliseconds: 250),
      () {
        _pickOpponent();
      },
    );
  }

  void _pickOpponent() {
    Player currentPlayer = context.read<Player>();
    List<Player> players = context.read<Players>().players;

    List alivePlayers = context.read<Players>().getActivePlayers();
    alivePlayers.remove(players.indexOf(currentPlayer));

    setState(() {
      _opponent = alivePlayers[Random().nextInt(alivePlayers.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isVisible ? 1 : 0,
      onEnd: () {
        if (!_isVisible) {
          widget.onBackClicked!();
        }
      },
      duration: const Duration(milliseconds: 160),
      curve: Curves.fastOutSlowIn,
      child: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  Icons.person,
                  key: ValueKey<String>(
                    DateTime.now().millisecondsSinceEpoch.toString(),
                  ),
                  size: 100,
                  color: _opponent == -1
                      ? Colors.white
                      : context.read<Players>().players[_opponent].getColor(
                          context.read<SettingNotifier>().isDarkTheme),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    setState(() {
                      _isVisible = false;
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Back"),
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    _pickOpponent();
                  },
                  child: const Text("Pick Again"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
