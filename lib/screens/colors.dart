import 'package:flutter/material.dart';

Map<String, List<Color>> colors = {
  "light": const [
    Color.fromRGBO(228, 82, 95, 1),
    Color.fromRGBO(156, 186, 96, 1),
    Color.fromRGBO(245, 143, 41, 1),
    Color.fromRGBO(147, 187, 222, 1),
    Color.fromRGBO(63, 116, 166, 1),
    Color.fromRGBO(107, 95, 145, 1),
    Color.fromRGBO(91, 162, 224, 1),
    Color.fromRGBO(255, 120, 124, 1),
    Color.fromRGBO(77, 205, 204, 1),
    Color.fromRGBO(253, 197, 86, 1),
    Color.fromRGBO(233, 91, 55, 1),
  ],
  "dark": const [
    Color.fromRGBO(67, 63, 64, 1),
    Color.fromRGBO(178, 172, 171, 1),
    Color.fromRGBO(114, 107, 104, 1),
    Color.fromRGBO(131, 135, 141, 1),
    Color.fromRGBO(121, 121, 121, 1),
    Color.fromRGBO(72, 61, 65, 1),
    Color.fromRGBO(200, 200, 200, 1),
    Color.fromRGBO(88, 98, 97, 1),
    Color.fromRGBO(148, 147, 145, 1),
  ],
};

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

    for (var i = 0; i < colors[theme]!.length; i++) {
      Color color = colors[theme]![i];

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(
            right: 20,
            bottom: 20,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.zero,
              primary: color,
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
