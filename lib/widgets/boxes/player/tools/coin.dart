import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PlayerBoxSettingsToolsCoin extends StatefulWidget {
  final void Function()? onBackClicked;

  const PlayerBoxSettingsToolsCoin({
    Key? key,
    this.onBackClicked,
  }) : super(key: key);

  @override
  State<PlayerBoxSettingsToolsCoin> createState() =>
      _PlayerBoxSettingsToolsCoinState();
}

class _PlayerBoxSettingsToolsCoinState
    extends State<PlayerBoxSettingsToolsCoin> {
  List<String> _results = [];

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
        _flipCoin();
      },
    );
  }

  void _flipCoin() {
    setState(() {
      _results.add(
        Random().nextInt(2) + 1 == 1 ? "tail" : "head",
      );
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Tail",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _results
                          .where((coin) => coin == "tail")
                          .length
                          .toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 30),
                    ),
                  ],
                ),
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
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 160),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Material(
                      borderRadius: BorderRadius.circular(50),
                      key: ValueKey<String>(
                          "head-" + _results.length.toString()),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          _flipCoin();
                        },
                        child: SvgPicture.asset(
                          "assets/icons/" +
                              (_results.isEmpty
                                  ? "coin_head"
                                  : "coin_" + _results[_results.length - 1]) +
                              ".svg",
                          fit: BoxFit.scaleDown,
                          width: 100,
                          color:
                              (_results.isEmpty ? Colors.white : Colors.orange),
                          semanticsLabel: 'Health',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    _flipCoin();
                  },
                  child: const Text("Flip Again"),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Head",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _results
                          .where((coin) => coin == "head")
                          .length
                          .toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 30),
                    ),
                  ],
                ),
                TextButton(
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    setState(() {
                      _results = [];
                    });
                    //_flipCoin();
                  },
                  child: const Text("Reset"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
