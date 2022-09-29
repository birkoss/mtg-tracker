// TODO: Options - Add player color customization
//  - Dark mode makes everything black/gray, I wish there would still be colour.

// TODO: Options - Choose Random Player
// - Smoother animation/transition instead of flashing WHITE windows poping around (from: JaqueLeKappa)

// TODO: Player Box
//  - See and Track
//    - Commander track time casted
//    - Storm Count
//    - Monarch
//    - Initiative
//  - Button + and -
//    - if it's held, it added/removed points by 5 instead of 1 at the time. As an option (from: JaqueLeKappa)

// UI & Glitch
//  - TODO: Only gripe i really have with it is that I don't find it a bit unpolished visually (which is to be expected at at this stage and by no means is meant like an insult).

// - Changing the image in the background would be fun!

// TODO: Anim PlayerBoxSettings
//  - Fade in background color
//  - Popup content slide up

// TODO: Change color when in Commander Damage State ?
// - Expand button when active with label (Apply) ?

// TODO: Animate when life = 0, poison = 10, one cmd = 21

// TODO: Select color within PlayerBox Settings
// - Selected colors are inactive
// - Refresh players and CommanderDamage boxes on changes

// TODO: Main Settings
// - Change default colors

import 'package:flutter/services.dart';
import 'package:mtgtracker/screens/coin_toss.dart';
import 'package:mtgtracker/screens/loading.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/material.dart';

import '../providers/layout.dart';
import '../providers/players.dart';
import '../providers/setting.dart';
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
        '/': (_) => const LoadingScreen(),
        '/play': (_) => const TrackerScreen(),
        //'/settings': (_) => const SettingScreen(),
        '/coin-toss': (_) => const CoinTossScreen()
      },
    );
  }
}
