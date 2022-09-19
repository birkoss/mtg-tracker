import 'package:flutter/material.dart';

class EmptyBox extends StatelessWidget {
  final Color color;

  const EmptyBox({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        color: color,
      ),
    );
  }
}
