import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/player.dart';
import '../../../../providers/players.dart';

class PlayerBoxSettingsToolsDice extends StatefulWidget {
  final void Function()? onBackClicked;

  const PlayerBoxSettingsToolsDice({
    Key? key,
    this.onBackClicked,
  }) : super(key: key);

  @override
  State<PlayerBoxSettingsToolsDice> createState() =>
      _PlayerBoxSettingsToolsDiceState();
}

class _PlayerBoxSettingsToolsDiceState
    extends State<PlayerBoxSettingsToolsDice> {
  bool _isVisible = false;

  int _dice = 6;
  int _value = 0;

  @override
  void initState() {
    super.initState();

    _pickValue();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() {
        _isVisible = true;
      }),
    );
  }

  void _pickValue() {
    setState(() {
      _value = Random().nextInt(_dice) + 1;
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
                child: Text(
                  _value.toString(),
                  key: ValueKey<String>(_value.toString()),
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: 70,
                        color: Theme.of(context).primaryColor,
                      ),
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
                Row(
                  children: [
                    Text(
                      "6",
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    Switch(
                      value: _dice == 20,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (bool value) {
                        setState(() {
                          _dice = (value ? 20 : 6);
                        });
                        _pickValue();
                      },
                    ),
                    Text(
                      "20",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    _pickValue();
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
