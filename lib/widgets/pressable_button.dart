import 'package:flutter/material.dart';

class PressableButton extends StatefulWidget {
  final bool isActive;
  final Widget inactiveWidget;
  final Color inactiveColor;
  final Color activeColor;
  final VoidCallback onToggle;

  const PressableButton({
    Key? key,
    required this.isActive,
    required this.inactiveWidget,
    required this.inactiveColor,
    required this.activeColor,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<PressableButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            color: widget.inactiveColor,
            border: Border.all(
              width: 3,
              color:
                  widget.isActive ? widget.activeColor : widget.inactiveColor,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onToggle,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: widget.isActive
                      ? Text(
                          "X",
                          textAlign: TextAlign.center,
                          key: const ValueKey<String>("X"),
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 20),
                        )
                      : widget.inactiveWidget,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
