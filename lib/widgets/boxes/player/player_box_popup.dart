import 'package:flutter/material.dart';

class PlayerBoxPopup extends StatefulWidget {
  static const animationDuration = 280;

  final Color backgroundColor;
  final Widget child;
  final VoidCallback? onPress;
  final bool autoHide;
  final bool isVisible;
  final VoidCallback? onHidden;

  const PlayerBoxPopup({
    Key? key,
    required this.backgroundColor,
    required this.child,
    this.autoHide = true,
    this.onHidden,
    this.onPress,
    this.isVisible = true,
  }) : super(key: key);

  @override
  State<PlayerBoxPopup> createState() => _PlayerBoxPopupState();
}

class _PlayerBoxPopupState extends State<PlayerBoxPopup> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isVisible ? 1 : 0,
      duration: const Duration(milliseconds: PlayerBoxPopup.animationDuration),
      child: Container(
        padding: const EdgeInsets.all(6),
        width: double.infinity,
        height: double.infinity,
        color: widget.backgroundColor,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPress,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
