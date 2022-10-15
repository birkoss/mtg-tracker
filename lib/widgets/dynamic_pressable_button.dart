import 'package:flutter/material.dart';

import '../widgets/pressable_button.dart';

class DynamicPressableButton extends StatelessWidget {
  final bool isActive;
  final int value;
  final IconData icon;
  final VoidCallback onToggle;

  const DynamicPressableButton({
    Key? key,
    required this.isActive,
    required this.value,
    required this.icon,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PressableButton(
      isVisible: true,
      isActive: isActive,
      inactiveWidget: value == 0
          ? Icon(
              icon,
              color: Colors.white,
            )
          : Stack(
              alignment: Alignment.centerLeft,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: Colors.white30,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    value.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 20),
                  ),
                ),
              ],
            ),
      activeColor: Colors.white,
      onToggle: onToggle,
    );
  }
}
