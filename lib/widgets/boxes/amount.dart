import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:mtgtracker/providers/setting.dart';
import 'package:provider/provider.dart';

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
  bool _isTooltipVisible = false;

  void updateAmount(int value) {
    _timerAmountChanges.reset();
    setState(() {
      _isTooltipVisible = true;
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
          _isTooltipVisible = false;
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
    SettingNotifier setting =
        Provider.of<SettingNotifier>(context, listen: false);

    void _changeValue(int modifier) {
      // Do NOT decrease bellow 0
      if (modifier == -1 && int.parse(widget.getValue()) <= 0) {
        return;
      }

      if (widget.setValue(modifier)) {
        updateAmount(modifier);
      }
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AmountText(
                isVisible: _isTooltipVisible,
                onHidden: () {
                  setState(() {
                    _amountChanges = 0;
                  });
                },
                amount: _amountChanges,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onPress,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        widget.getValue(),
                        overflow: TextOverflow.visible,
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                              fontSize: setting.playersNumber == 6 &&
                                      setting.tableLayout == 2
                                  ? 30
                                  : 45,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
              widget.child != null
                  ? widget.child!
                  : const SizedBox(
                      height: 20,
                    ),
            ],
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
