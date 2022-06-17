import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Toggles extends StatefulWidget {
  final List<Map<String, String>> values;
  final int defaultValue;
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
      _isSelected.add(
        widget.defaultValue == int.parse(element["value"].toString()),
      );
    }
  }

  List<Widget> _getToggles(BuildContext context) {
    List<Widget> toggles = [];
    for (Map<String, String> element in widget.values) {
      toggles.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: element['icon'] != null
              ? Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/" + element['icon'].toString(),
                      height: 30,
                      fit: BoxFit.scaleDown,
                      color: Theme.of(context).textTheme.bodySmall!.color,
                    ),
                    Text(
                      element['label'].toString(),
                    ),
                  ],
                )
              : Text(
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
      children: _getToggles(context),
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < _isSelected.length; i++) {
            _isSelected[i] = i == index;
          }
        });

        widget.onChanged(int.parse(widget.values[index]["value"].toString()));
      },
      isSelected: _isSelected,
    );
  }
}
