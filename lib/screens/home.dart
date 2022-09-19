import 'package:flutter/material.dart';
import 'package:mtgtracker/providers/player.dart';
import 'package:mtgtracker/providers/players.dart';
import 'package:mtgtracker/providers/setting.dart';
import 'package:provider/provider.dart';

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
                context.read<Players>().addPlayer(Player(id: "1"));
                context.read<Players>().addPlayer(Player(id: "2"));
                context.read<Players>().addPlayer(Player(id: "3"));
                context.read<Players>().addPlayer(Player(id: "4"));

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
