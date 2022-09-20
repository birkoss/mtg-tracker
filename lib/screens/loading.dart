import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mtgtracker/providers/layout.dart';
import 'package:mtgtracker/providers/players.dart';
import 'package:mtgtracker/providers/setting.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.watch<SettingNotifier>().isReady) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        context
            .read<Players>()
            .generate(context.read<SettingNotifier>().playersNumber);

        context.read<LayoutNotifier>().generate(
              context.read<Players>().players,
              context.read<SettingNotifier>(),
            );

        Navigator.pushReplacementNamed(context, '/play');
      });
    }
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
