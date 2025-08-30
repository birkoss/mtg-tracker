import 'package:flutter/material.dart';

class TileButton extends StatelessWidget {
  final void Function() onPress;
  final IconData icon;
  final bool isDisabled;
  final String label;

  const TileButton({
    Key? key,
    required this.onPress,
    required this.icon,
    required this.label,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (isDisabled ? () {} : onPress),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .primaryColor
                        .withAlpha((isDisabled ? (0.3 * 255).toInt() : 255)),
                    border: Border.all(
                      color: Theme.of(context)
                          .primaryColor
                          .withAlpha((isDisabled ? (0.3 * 255).toInt() : 255)),
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black
                        .withAlpha((isDisabled ? (0.3 * 255).toInt() : 255)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
