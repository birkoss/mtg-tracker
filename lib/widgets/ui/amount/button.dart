import 'package:flutter/material.dart';

class AmountButton extends StatelessWidget {
  final String label;
  final VoidCallback onPress;

  const AmountButton({
    Key? key,
    required this.label,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPress,
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.25,
          height: double.infinity,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white30,
              fontSize: 40,
            ),
          ),
        ),
      ),
    );
  }
}
