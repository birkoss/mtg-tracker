import 'package:flutter/material.dart';
import 'package:mtgtracker/widgets/boxes/player/tools/coin.dart';
import 'package:mtgtracker/widgets/boxes/player/tools/opponent.dart';

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
    _controller = TabController(length: 3, vsync: this, initialIndex: 1);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() {
        _isVisible = true;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
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
                        Tab(text: 'Colors'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TabBarView(
                      controller: _controller,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
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
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
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
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Flip Coins",
                                      textAlign: TextAlign.start,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size.zero, // Set this
                                        padding:
                                            const EdgeInsets.all(6), // and this
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
                                      child: const Icon(Icons.monetization_on),
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
                                        "Pick Random Opponent",
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size.zero, // Set this
                                        padding:
                                            const EdgeInsets.all(6), // and this
                                      ),
                                      onPressed: () {
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
                                      child: const Icon(Icons.casino),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Text("Coming Soon!"),
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

                        //widget.onClose,
                      },
                      icon: const Icon(Icons.close),
                      label: const Text("Close"),
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
