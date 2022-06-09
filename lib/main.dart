// @TODO: Allow to change the direction of the commander view, instead of entering OUR cmd damage, changing the cmd damage dealt
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mtgtracker/providers/setting.dart';
import 'package:mtgtracker/screens/loading.dart';
import 'package:mtgtracker/themes/custom.dart';
import 'package:provider/provider.dart';

import 'screens/tracker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => SettingNotifier(),
      child: Consumer<SettingNotifier>(
        builder: (context, SettingNotifier notifier, child) {
          print("main.build()");
          return MaterialApp(
            title: 'MTG Tracker',
            debugShowCheckedModeBanner: false,
            theme: CustomTheme.lightTheme,
            home: notifier.isReady
                ? const TrackerScreen()
                : const LoadingScreen(),
          );
        },
      ),
    );
  }
}
