import 'package:flutter/material.dart';

import '../../widgets/ui/amount/button.dart';

class ManaBox extends StatefulWidget {
  final Color color;

  const ManaBox({
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  _ManaBox createState() => _ManaBox();
}

class _ManaBox extends State<ManaBox> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    void _changeValue(int modifier) {
      // Do NOT decrease bellow 0
      if (modifier == -1 && _value <= 0) {
        return;
      }

      setState(() {
        _value += modifier;
      });
    }

    return Container(
      color: widget.color,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              _value.toString(),
              key: ValueKey<String>(_value.toString()),
              overflow: TextOverflow.visible,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 24,
                    color: widget.color == Colors.white
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                  ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: AmountButton(
                  isDarkBackground: widget.color == Colors.white,
                  label: "-",
                  onPress: () {
                    _changeValue(-1);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: AmountButton(
                  isDarkBackground: widget.color == Colors.white,
                  label: "+",
                  onPress: () {
                    _changeValue(1);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
