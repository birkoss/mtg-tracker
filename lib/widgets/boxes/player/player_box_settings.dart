import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Container(
        color: widget.backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: TabBar(
                controller: _controller,
                tabs: const [
                  Tab(text: 'Settings'),
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
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                "Has a partner",
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.bodyText1,
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
                            children: [
                              Text(
                                "Is Dead!",
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.bodyText1,
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
                  const Align(
                    alignment: Alignment.center,
                    child: Text("Coming Soon!"),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: ElevatedButton.icon(
                onPressed: widget.onClose,
                icon: const Icon(Icons.close),
                label: const Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
