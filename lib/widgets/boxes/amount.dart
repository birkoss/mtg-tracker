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
  final Function getLabel;
  final Function setValue;
  final Function getValue;
  final bool bigFont;
  final bool lightMode;
  final Function()? onPress;
  final Function()? onAutoClose;

  const AmountBox({
    Key? key,
    this.child,
    required this.setValue,
    required this.getIcon,
    required this.getLabel,
    required this.getValue,
    this.lightMode = true,
    this.bigFont = true,
    this.onPress,
    this.onAutoClose,
  }) : super(key: key);

  @override
  _AmountBox createState() => _AmountBox();
}

class _AmountBox extends State<AmountBox> {
  int _amountChanges = 0;
  late RestartableTimer _timerAmountChanges;
  late RestartableTimer _timerAutoClose;
  bool _isTooltipVisible = false;

  void updateAmount(int value) {
    _timerAmountChanges.reset();
    _timerAutoClose.reset();

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

    _timerAutoClose = RestartableTimer(
      const Duration(seconds: 5),
      () {
        if (widget.onAutoClose != null) {
          widget.onAutoClose!();
        }
      },
    );
  }

  @override
  void dispose() {
    _timerAmountChanges.cancel();
    _timerAutoClose.cancel();
    super.dispose();
  }

  void _changeValue(int modifier) {
    // Do NOT decrease bellow 0
    if (modifier == -1 && int.parse(widget.getValue()) <= 0) {
      return;
    }

    if (widget.setValue(modifier)) {
      updateAmount(modifier);
    }
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = 54;
    if (context.read<SettingNotifier>().playersNumber >= 6) {
      fontSize = 30;
    }
    if (!widget.bigFont) {
      fontSize = 40;
    }

    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Opacity(
              opacity: 1,
              child: Text(
                widget.getLabel(),
                style: Theme.of(context).textTheme.headline1!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(widget.getLabel() == "" ? 20 : 30),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: widget.getIcon() != ""
                ? SvgPicture.asset(
                    "assets/icons/" + widget.getIcon() + ".svg",
                    key: ValueKey<String>(widget.getIcon()),
                    fit: BoxFit.scaleDown,
                    color: Colors.white10,
                    semanticsLabel: 'Health',
                  )
                : null,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                widget.getValue(),
                key: ValueKey<String>(widget.getValue()),
                overflow: TextOverflow.visible,
                style: Theme.of(context).textTheme.headline1!.copyWith(
                      fontSize: fontSize,
                      color: widget.lightMode
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
              ),
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
                isDarkBackground: !widget.lightMode,
                label: "-",
                onPress: () {
                  _changeValue(-1);
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: AmountButton(
                isDarkBackground: !widget.lightMode,
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
