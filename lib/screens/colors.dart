import 'package:flutter/material.dart';

import '../providers/setting.dart';

class SettingColorsScreenArguments {
  final Color currentColor;
  final List<Color> usedColors;

  final void Function(Color) onChanged;

  SettingColorsScreenArguments({
    required this.currentColor,
    required this.usedColors,
    required this.onChanged,
  });
}

class SettingColorsScreen extends StatefulWidget {
  static const routeName = '/setting/colors';

  const SettingColorsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingColorsScreen> createState() => _SettingColorsScreenState();
}

class _SettingColorsScreenState extends State<SettingColorsScreen> {
  Color _currentColor = Colors.white;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        SettingColorsScreenArguments args = ModalRoute.of(context)!
            .settings
            .arguments as SettingColorsScreenArguments;
        setState(() {
          _currentColor = args.currentColor;
        });
      },
    );
  }

  Icon _getIcon(Color color) {
    SettingColorsScreenArguments args = ModalRoute.of(context)!
        .settings
        .arguments as SettingColorsScreenArguments;

    if (_currentColor == color) {
      return const Icon(
        Icons.check,
      );
    }

    if (args.usedColors.contains(color)) {
      return const Icon(
        Icons.close,
      );
    }

    return Icon(
      Icons.check,
      color: color,
    );
  }

  List<Widget> _generateColors(String theme) {
    SettingColorsScreenArguments args = ModalRoute.of(context)!
        .settings
        .arguments as SettingColorsScreenArguments;

    List<Widget> widgets = [];

    for (var i = 0; i < SettingNotifier.colorSchemes[theme]!.length; i++) {
      Color color = SettingNotifier.colorSchemes[theme]![i];

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(
            right: 20,
            bottom: 20,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.zero,
              backgroundColor: color,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            ),
            onPressed: () {
              if (_currentColor == color) {
                return;
              }

              if (args.usedColors.contains(color)) {
                return;
              }

              setState(() {
                _currentColor = color;
              });

              args.onChanged(color);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _getIcon(color),
            ),
          ),
        ),
      );
    }

    return [
      Text(
        theme[0].toUpperCase() + theme.substring(1),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
      ),
      const SizedBox(height: 20),
      Wrap(
        children: widgets,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Colors Schemes"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._generateColors("light"),
              ..._generateColors("dark"),
            ],
          ),
        ),
      ),
    );
  }
}
