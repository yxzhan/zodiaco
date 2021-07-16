/// Flutter code sample for CircularProgressIndicator

// This example shows a [CircularProgressIndicator] with a changing value.

import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class LoadingCircle extends StatefulWidget {
  final double size;
  final int duration;

  const LoadingCircle({Key key, this.size = 50, this.duration = 5})
      : super(key: key);

  @override
  _LoadingCircleState createState() => _LoadingCircleState();
}

/// This is the private State class that goes with MyStatefulWidget.
/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _LoadingCircleState extends State<LoadingCircle>
    with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: false);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: SizedBox(
        child: CircularProgressIndicator(
          value: controller.value,
          semanticsLabel: 'Linear progress indicator',
        ),
        height: widget.size,
        width: widget.size,
      ),
    );
  }
}
