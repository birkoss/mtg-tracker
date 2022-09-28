// from: Dropkick-Octopus
// - Replace light blue

//  - Add more dice (D4, D6, D8 and D20)

// Commander track time casted

// from: Toxxazhe
//  - Maybe allow more dice to be roll at the same time

// from: JaqueLeKappa
// - energy counters, Storm count, Monarch, Initiative and floating mana can be added as well.
// - Flip Coin
//  - The button itself is small and off to the side so I've had times where i pressed it and it didn't register.
//  - I also was confused at first why it didn't say "flip". With everything else being so intuitive this stood out to me.
//  - My suggestion is to remove the button and have players tap the coin itself, it's larger and its what came naturally to me (but that may not be true for all players).
//  - Secondly, when you reset the "heads/tails" it will automatically pick one side so instead of the score being 0-0 it's 1-0 or -0-1. Not sure if that's intended but that's a very small nitpick.

// - +/- buttons :  On that note, I wish that if it's held, it added/removed points by 5 instead of 1 at the time, this would make large life gain/loss moments a bit smoother.

// - Dark mode makes everything black/gray, I wish there would still be colour.

// - Selecting a random player feels a bit jarring at the moment with the bright window hopping around, maybe something smoother could be made in the future?

// - While in a 3 player game and have the "all around "setting, the middle " ||| " button is in the center of the screen and clips one of the commander damage boxes, nothing big but maybe could be moved.

// - Changing the image in the background would be fun!

// - Here's a personal wish: Add a "reduce/add lifetotal by x part, rounded up/down" (example, lose a third of your life rounded up/down), there's a bunch of cards that do this and if there are multiple instances of it, a calculator is usually brought up so if this app had it, I'd be over the moon about it.

// - Only gripe i really have with it is that I don't find it a bit unpolished visually (which is to be expected at at this stage and by no means is meant like an insult).

// Add experience and energy counter

// Add color customization

// Randomness check: Be sure it's as random as it can be

// Track Monarch

// Replace light blue with ANOTHER color while picking a better solution to show which opponent
// - Maybe an arrow?
// - Configure for other page layout
// - Disable pick an opponent for 2 players game

// @TODO: Anim PlayerBoxSettings
//  - Fade in background color
//  - Popup content slide up

// @TODO: Change color when in Commander Damage State ?
// - Expand button when active with label (Apply) ?

// @TODO: Animate when life = 0, poison = 10, one cmd = 21

// @TODO: Select color within PlayerBox Settings
// - Selected colors are inactive
// - Refresh players and CommanderDamage boxes on changes

// @TODO: Main Settings
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
