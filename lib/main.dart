import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter/material.dart';

import '../providers/history.dart';
import '../providers/layout.dart';
import '../providers/players.dart';
import '../providers/setting.dart';

import '../screens/colors.dart';
import '../screens/history.dart';
import '../screens/loading.dart';
import '../screens/tracker.dart';

import '../themes/custom.dart';

/*
  - Prevent screen lock
  - Prevent screen rotation
  - Enable providers
*/
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  WakelockPlus.enable();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingNotifier()),
        ChangeNotifierProvider(create: (_) => Players()),
        ChangeNotifierProvider(create: (_) => LayoutNotifier()),
        ChangeNotifierProvider(create: (_) => HistoryNotifier()),
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
        '/history': (_) => const HistoryScreen(),
      },
    );
  }
}
