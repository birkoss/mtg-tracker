// @TODO: Dice Roll with only ALIVE player

// @TODO: Better pick player, show a random hover on each player until one is picked
// @TODO: When changing states (commander, normal, poison), reset the amount modifyer overlay
// @TODO: Animate when life = 0, poison = 10, one cmd = 21

// @TODO: Select color within PlayerBox Settings
// - Selected colors are inactive
// - Refresh players and CommanderDamage boxes on changes

// @TODO: Main Settings
// - Change default colors

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/material.dart';

import '../providers/layout.dart';
import '../providers/players.dart';
import '../providers/setting.dart';
import '../screens/home.dart';
import '../screens/tracker.dart';
import '../themes/custom.dart';

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
        ChangeNotifierProvider(create: (_) => SettingNotifier()),
        ChangeNotifierProvider(create: (_) => Players()),
        ChangeNotifierProvider(create: (_) => LayoutNotifier()),
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
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/play': (_) => const TrackerScreen(),
        //'/settings': (_) => const SettingScreen(),
      },
    );
  }
}
