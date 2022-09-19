// @TODO: New Game: Reset all showSettings, etc... to NORMAL view
// @TODO: Pick Player: Do NOT reset the showPoison, etc.
// @TODO: Better pick player, show a random hover on each player until one is picked

import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/material.dart';
import 'package:mtgtracker/providers/setting.dart';
import 'package:mtgtracker/screens/loading.dart';
import 'package:mtgtracker/themes/custom.dart';
import 'package:provider/provider.dart';

import 'screens/tracker.dart';

/*
  - Prevent screen lock
  - Prevent screen rotation
  - Enable providers
*/
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Wakelock.enable();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingNotifier(),
        ),
      ],
      child: const MtgTrackerApp(),
    ),
  );
}

class MtgTrackerApp extends StatelessWidget {
  const MtgTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MTG Life Tracker',
      debugShowCheckedModeBanner: false,
      theme: context.watch<SettingNotifier>().isDarkTheme
          ? CustomTheme.darkTheme
          : CustomTheme.lightTheme,
      home: context.watch<SettingNotifier>().isReady
          ? const TrackerScreen()
          : const LoadingScreen(),
    );
  }
}
