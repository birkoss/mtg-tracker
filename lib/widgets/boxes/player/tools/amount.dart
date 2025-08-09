import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../widgets/boxes/amount.dart';

class PlayerBoxSettingsToolsAmount extends StatefulWidget {
  final void Function()? onBackClicked;
  final int defaultValue;

  const PlayerBoxSettingsToolsAmount({
    Key? key,
    this.onBackClicked,
    this.defaultValue = 40,
  }) : super(key: key);

  @override
  State<PlayerBoxSettingsToolsAmount> createState() =>
      _PlayerBoxSettingsToolsAmountState();
}

class _PlayerBoxSettingsToolsAmountState
    extends State<PlayerBoxSettingsToolsAmount> {
  bool _isVisible = false;

  bool _isAdding = true;
  bool _byThird = false;
  bool _roundedDown = true;

  int _amount = 10;
  int _value = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() {
        _amount = widget.defaultValue;
        _isVisible = true;
      }),
    );

    waitForFirstPick();
  }

  void waitForFirstPick() async {
    await Future.delayed(
      const Duration(milliseconds: 250),
      () {
        _calculate();
      },
    );
  }

  void _calculate() {
    setState(() {
      double calculatedAmount = _amount / (_byThird ? 3 : 2);

      int modifier =
          (_roundedDown ? calculatedAmount.floor() : calculatedAmount.ceil());

      _value = _amount + modifier * (_isAdding ? -1 : 1);
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Add",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                            Switch(
                                value: _isAdding,
                                onChanged: (bool value) {
                                  setState(() {
                                    _isAdding = value;
                                  });

                                  _calculate();
                                }),
                            Text(
                              "Reduce",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: AmountBox(
                            bigFont: false,
                            lightMode: false,
                            setValue: (int modifier) {
                              setState(() {
                                _amount += modifier;

                                _amount = max(0, _amount);
                              });
                              _calculate();
                              return true;
                            },
                            getIcon: () {
                              return "health";
                            },
                            getLabel: () {
                              return "";
                            },
                            getValue: () {
                              return _amount.toString();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "By",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Half",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                            Switch(
                              value: _byThird,
                              onChanged: (bool value) {
                                setState(() {
                                  _byThird = value;
                                });

                                _calculate();
                              },
                            ),
                            Text(
                              "Third",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                          ],
                        ),
                        Text(
                          "Rounded",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Up",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                            Switch(
                              value: _roundedDown,
                              onChanged: (bool value) {
                                setState(() {
                                  _roundedDown = value;
                                });
                                _calculate();
                              },
                            ),
                            Text(
                              "Down",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
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
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Row(
                    children: [
                      Text(
                        "Result: ",
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  fontSize: 22,
                                  color: Theme.of(context).primaryColor,
                                ),
                      ),
                      Text(
                        _value.toString(),
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  fontSize: 30,
                                  color: Theme.of(context).primaryColor,
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
