import 'package:flutter/services.dart';
import 'package:mtgtracker/screens/colors.dart';
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
        '/setting/colors': (_) => const SettingColorsScreen(),
      },
    );
  }
}
