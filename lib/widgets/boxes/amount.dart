import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mtgtracker/providers/setting.dart';
import 'package:provider/provider.dart';

import '../../widgets/ui/amount/button.dart';
import '../../widgets/ui/amount/text.dart';

class AmountBox extends StatefulWidget {
  final Widget? child;
  final Function getIcon;
  final Function setValue;
  final Function getValue;
  final Function()? onPress;

  const AmountBox({
    Key? key,
    this.child,
    required this.setValue,
    required this.getIcon,
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

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SvgPicture.asset(
            "assets/icons/" + widget.getIcon() + ".svg",
            fit: BoxFit.scaleDown,
            color: Colors.white10,
            semanticsLabel: 'Health',
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              widget.getValue(),
              overflow: TextOverflow.visible,
              style:
                  Theme.of(context).textTheme.headline1!.copyWith(fontSize: 40),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: AmountText(
              isVisible: _isTooltipVisible,
              onHidden: () {
                setState(() {
                  _amountChanges = 0;
                });
              },
              amount: _amountChanges,
            ),
          ),
        ),
        Row(
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
              child: AmountButton(
                label: "+",
                onPress: () {
                  _changeValue(1);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
