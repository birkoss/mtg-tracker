import 'package:flutter/material.dart';

class SlideInContainer extends StatefulWidget {
  final Widget child;
  final void Function()? onHidden;

  const SlideInContainer({
    Key? key,
    required this.child,
    this.onHidden,
  }) : super(key: key);

  @override
  State<SlideInContainer> createState() => _SlideInContainerState();
}

class _SlideInContainerState extends State<SlideInContainer> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() {
        _isVisible = true;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: Offset(0, _isVisible ? 0 : 1),
      onEnd: () {
        if (!_isVisible) {
          widget.onHidden!();
        }
      },
      duration: const Duration(milliseconds: 160),
      child: widget.child,
    );
  }
}
