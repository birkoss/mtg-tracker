import 'package:flutter/material.dart';

class AmountText extends StatelessWidget {
  final int amount;

  const AmountText({
    Key? key,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: amount == 0 ? 0.0 : 1.0,
      child: Text(
        amount == 0 ? "" : (amount > 0 ? "+" : "") + amount.toString(),
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }
}
