import 'package:flutter/material.dart';

class AmountText extends StatelessWidget {
  final int amount;
  final bool isVisible;
  final Function? onHidden;

  const AmountText({
    Key? key,
    required this.amount,
    required this.isVisible,
    required this.onHidden,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      onEnd: () {
        if (!isVisible && onHidden != null) {
          onHidden!();
        }
      },
      opacity: isVisible ? 1.0 : 0.0,
      child: Text(
        amount == 0 ? "" : (amount > 0 ? "+" : "") + amount.toString(),
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }
}
