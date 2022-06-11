import 'package:flutter/material.dart';

class Toggles extends StatefulWidget {
  final List<Map<String, String>> values;
  final String defaultValue;
  final Function onChanged;

  const Toggles({
    Key? key,
    required this.values,
    required this.defaultValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<Toggles> createState() => _TogglesState();
}

class _TogglesState extends State<Toggles> {
  final List<bool> _isSelected = [];

  @override
  void initState() {
    super.initState();

    for (Map<String, String> element in widget.values) {
      _isSelected.add(widget.defaultValue == element["value"].toString());
    }
  }

  List<Widget> _getToggles() {
    List<Widget> toggles = [];
    for (Map<String, String> element in widget.values) {
      toggles.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            element['label'].toString(),
          ),
        ),
      );
    }
    return toggles;
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      children: _getToggles(),
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < _isSelected.length; i++) {
            _isSelected[i] = i == index;
          }
        });

        widget.onChanged(widget.values[index]["value"]);
      },
      isSelected: _isSelected,
    );
  }
}
