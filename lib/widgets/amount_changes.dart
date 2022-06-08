import 'package:flutter/material.dart';

class AmountChanges extends StatelessWidget {
  final int amount;

  const AmountChanges({Key? key, required this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return amount == 0
        ? const Text(
            "",
            style: TextStyle(
              fontSize: 20,
            ),
          )
        : Text(
            (amount > 0 ? "+" : "") + amount.toString(),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white70,
            ),
          );
  }
}
