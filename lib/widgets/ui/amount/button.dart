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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onPanCancel: () {
          _timer?.cancel();
        },
        onPanDown: (_) {
          _timer = Timer.periodic(const Duration(milliseconds: 150), (_) {
            widget.onPress();
          });
        },
        child: InkWell(
          onTap: widget.onPress,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.25,
            height: double.infinity,
            child: Text(
              widget.label,
              style: Theme.of(context).textTheme.headline1!.copyWith(
                    color: Colors.white30,
                    fontSize: 40,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
