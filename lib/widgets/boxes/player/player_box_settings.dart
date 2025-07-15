import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/player.dart';
import '../../../providers/setting.dart';

import '../../../widgets/boxes/mana.dart';
import '../../../widgets/boxes/player/tools/amount.dart';
import '../../../widgets/boxes/player/tools/coin.dart';
import '../../../widgets/boxes/player/tools/dice.dart';
import '../../../widgets/boxes/player/tools/opponent.dart';

class PlayerBoxSettings extends StatefulWidget {
  final Color backgroundColor;

  final bool hasPartner;
  final void Function(bool) onPartnerChanged;

  final bool isDead;
  final void Function(bool) onDeadChanged;

  final void Function() onClose;

  const PlayerBoxSettings({
    Key? key,
    required this.backgroundColor,
    required this.hasPartner,
    required this.isDead,
    required this.onClose,
    required this.onDeadChanged,
    required this.onPartnerChanged,
  }) : super(key: key);

  @override
  State<PlayerBoxSettings> createState() => _PlayerBoxSettingsState();
}

class _PlayerBoxSettingsState extends State<PlayerBoxSettings>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  bool _isVisible = false;

  final List<Widget> _tools = [];

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 3,
      vsync: this,
      initialIndex: (widget.isDead ? 0 : 1),
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() {
        _isVisible = true;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 6, right: 6),
      child: AnimatedSlide(
        offset: Offset(0, _isVisible ? 0 : 1.1),
        onEnd: () {
          if (!_isVisible) {
            widget.onClose();
          }
        },
        duration: const Duration(milliseconds: 160),
        curve: Curves.fastOutSlowIn,
        child: Container(
          color: widget.backgroundColor,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 40,
                    decoration:
                        BoxDecoration(color: Theme.of(context).primaryColor),
                    child: TabBar(
                      indicatorColor: Colors.white,
                      indicatorWeight: 6,
                      controller: _controller,
                      tabs: const [
                        Tab(text: 'Settings'),
                        Tab(text: 'Tools'),
                        Tab(text: 'Mana Pool'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TabBarView(
                      controller: _controller,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Has a partner",
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        Switch(
                                          value: widget.hasPartner,
                                          onChanged: widget.onPartnerChanged,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Is Dead!",
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        Switch(
                                          value: widget.isDead,
                                          onChanged: widget.onDeadChanged,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _isVisible = false;
                                  });
                                },
                                icon: const Icon(Icons.close),
                                label: const Text("Close"),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Flip Coin",
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size.zero,
                                            padding: const EdgeInsets.all(6),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _tools.add(
                                                PlayerBoxSettingsToolsCoin(
                                                  onBackClicked: () {
                                                    setState(() {
                                                      _tools.clear();
                                                    });
                                                  },
                                                ),
                                              );
                                            });
                                          },
                                          child:
                                              const Icon(Icons.monetization_on),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        FittedBox(
                                          child: Text(
                                            "Pick Opponent",
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size.zero,
                                            padding: const EdgeInsets.all(6),
                                          ),
                                          onPressed: context
                                                      .read<SettingNotifier>()
                                                      .playersNumber ==
                                                  2
                                              ? null
                                              : () {
                                                  setState(() {
                                                    _tools.add(
                                                      PlayerBoxSettingsToolsOpponent(
                                                        onBackClicked: () {
                                                          setState(() {
                                                            _tools.clear();
                                                          });
                                                        },
                                                      ),
                                                    );
                                                  });
                                                },
                                          child: const Icon(Icons.person),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        FittedBox(
                                          child: Text(
                                            "Roll Dice",
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size.zero,
                                            padding: const EdgeInsets.all(6),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _tools.add(
                                                PlayerBoxSettingsToolsDice(
                                                  onBackClicked: () {
                                                    setState(() {
                                                      _tools.clear();
                                                    });
                                                  },
                                                ),
                                              );
                                            });
                                          },
                                          child: const Icon(Icons.casino),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        FittedBox(
                                          child: Text(
                                            "Amount",
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size.zero,
                                            padding: const EdgeInsets.all(6),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _tools.add(
                                                PlayerBoxSettingsToolsAmount(
                                                  defaultValue: context
                                                      .read<Player>()
                                                      .health,
                                                  onBackClicked: () {
                                                    setState(() {
                                                      _tools.clear();
                                                    });
                                                  },
                                                ),
                                              );
                                            });
                                          },
                                          child: const Icon(Icons.calculate),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _isVisible = false;
                                  });
                                },
                                icon: const Icon(Icons.close),
                                label: const Text("Close"),
                              ),
                            ),
                          ],
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: ManaBox(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ManaBox(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ManaBox(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: ManaBox(
                                      color: Colors.red,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ManaBox(color: Colors.green),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ManaBox(
                                      color: Color.fromRGBO(200, 200, 200, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_tools.isNotEmpty) _tools[0],
            ],
          ),
        ),
      ),
    );
  }
}
