import 'dart:math';

import 'package:flutter/material.dart';

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

  bool _selectDice = false;

  int _dice = 6;
  int _value = 0;

  final List<String> _results = [];

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
        _pickValue();
      },
    );
  }

  void _pickValue() {
    setState(() {
      if (_value != 0) {
        _results.add(_value.toString());
      }

      _value = Random().nextInt(_dice) + 1;
    });
  }

  List<Widget> _generateDices() {
    List<Widget> widgets = [];

    List<int> dices = [4, 6, 8, 10, 12, 20];
    for (int dice in dices) {
      widgets.add(
        TextButton.icon(
          onPressed: () {
            setState(() {
              _dice = dice;
              _selectDice = false;
              _results.clear();
              _value = 0;
            });

            // Wait a frame to pick the Value, to trigger the AnimatedSwitcher on the Text
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _pickValue();
            });
          },
          icon: const Icon(Icons.casino),
          label: Text(
            "D" + dice.toString(),
          ),
        ),
      );
    }

    return widgets;
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
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        _results.isEmpty ? "" : "Previous results: ",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      if (_results.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                            itemCount: _results.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                _results[_results.length - index - 1] +
                                    (index < _results.length - 1 ? "," : ""),
                                style: index == 0
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontSize: 16,
                                          color: Theme.of(context).primaryColor,
                                        )
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontSize: 16,
                                          color: Theme.of(context).primaryColor,
                                        ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 160),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Text(
                      _value == 0 ? "" : _value.toString(),
                      key: ValueKey<String>(_value.toString()),
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectDice = true;
                        });
                      },
                      icon: const Icon(Icons.casino),
                      label: Text(
                        "D" + _dice.toString(),
                      ),
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
            AnimatedScale(
              scale: _selectDice ? 1 : 0,
              onEnd: () {
                if (!_selectDice) {
                  //widget.onBackClicked!();
                }
              },
              duration: const Duration(milliseconds: 160),
              curve: Curves.fastOutSlowIn,
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Select a dice size",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    Wrap(
                      children: _generateDices(),
                    ),
                    TextButton.icon(
                      style: const ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectDice = false;
                        });
                      },
                      icon: const Icon(Icons.cancel),
                      label: const Text("Cancel"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
