import 'package:async/async.dart';
import 'package:flutter/material.dart';

import '../../widgets/ui/amount/button.dart';
import '../../widgets/ui/amount/text.dart';

class AmountBox extends StatefulWidget {
  final Widget? child;
  final Function setValue;
  final Function getValue;
  final Function()? onPress;

  const AmountBox({
    Key? key,
    this.child,
    required this.setValue,
    required this.getValue,
    this.onPress,
  }) : super(key: key);

  @override
  _AmountBox createState() => _AmountBox();
}

class _AmountBox extends State<AmountBox> {
  int _amountChanges = 0;
  late RestartableTimer _timerAmountChanges;

  void updateAmount(int value) {
    _timerAmountChanges.reset();
    setState(() {
      _amountChanges += value;
    });
  }

  @override
  void initState() {
    super.initState();

    _timerAmountChanges = RestartableTimer(
      const Duration(seconds: 2),
      () {
        setState(() {
          print("set state to 0...");
          _amountChanges = 0;
        });
      },
    );
  }

  @override
  void dispose() {
    _timerAmountChanges.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _changeValue(int modifier) {
      updateAmount(modifier);
      widget.setValue(modifier);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: AmountButton(
            label: "-",
            onPress: () {
              _changeValue(-1);
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPress,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AmountText(
                    amount: _amountChanges,
                  ),
                  Text(
                    widget.getValue(),
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  widget.child != null
                      ? widget.child!
                      : const SizedBox(
                          height: 2,
                        ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: AmountButton(
            label: "+",
            onPress: () {
              _changeValue(1);
            },
          ),
        ),
      ],
    );
  }
}
