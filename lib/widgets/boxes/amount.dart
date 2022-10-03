import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
            child: SvgPicture.asset(
              "assets/icons/" + widget.getIcon() + ".svg",
              key: ValueKey<String>(widget.getIcon()),
              fit: BoxFit.scaleDown,
              color: Colors.white10,
              semanticsLabel: 'Health',
            ),
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
                      fontSize: widget.bigFont ? 54 : 40,
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
