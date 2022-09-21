import 'package:flutter/material.dart';

class PlayerBoxPopup extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;
  final VoidCallback? onPress;

  const PlayerBoxPopup({
    Key? key,
    required this.backgroundColor,
    required this.child,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      width: double.infinity,
      height: double.infinity,
      color: backgroundColor,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPress,
          child: child,
        ),
      ),
    );
  }
}
