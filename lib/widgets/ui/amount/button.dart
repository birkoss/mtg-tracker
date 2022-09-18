import 'dart:async';

import 'package:flutter/material.dart';

class AmountButton extends StatefulWidget {
  final String label;
  final VoidCallback onPress;

  const AmountButton({
    Key? key,
    required this.label,
    required this.onPress,
  }) : super(key: key);

  @override
  State<AmountButton> createState() => _AmountButtonState();
}

class _AmountButtonState extends State<AmountButton> {
  Timer? _timer;
  Timer? _holdingDelay;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onPanEnd: (_) {
          _timer?.cancel();
          _holdingDelay?.cancel();
        },
        onPanCancel: () {
          _timer?.cancel();
          _holdingDelay?.cancel();
        },
        onPanDown: (_) {
          _holdingDelay = Timer(const Duration(milliseconds: 250), () {
            _timer = Timer.periodic(const Duration(milliseconds: 150), (_) {
              widget.onPress();
            });
          });
        },
        child: InkWell(
          onTap: widget.onPress,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              widget.label,
              style: Theme.of(context).textTheme.headline1!.copyWith(
                    color: Colors.white30,
                    fontSize: 30,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
