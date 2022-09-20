import 'package:flutter/material.dart';
import 'package:mtgtracker/providers/layout.dart';
import 'package:mtgtracker/providers/setting.dart';
import 'package:provider/provider.dart';

import '../providers/players.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Mtg Life Tracker"),
            ElevatedButton.icon(
              onPressed: () {
                context
                    .read<Players>()
                    .generate(context.read<SettingNotifier>().playersNumber);

                context.read<LayoutNotifier>().generate(
                      context.read<Players>().players,
                      context.read<SettingNotifier>(),
                    );

                Navigator.pushNamed(context, '/play');
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text("New Game"),
            )
          ],
        ),
      ),
    );
  }
}
