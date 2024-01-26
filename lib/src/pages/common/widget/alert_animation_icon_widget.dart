import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AlertAnimationIconWidget extends StatefulWidget {
  const AlertAnimationIconWidget({super.key});

  @override
  State<AlertAnimationIconWidget> createState() =>
      _AlertAnimationIconWidgetState();
}

class _AlertAnimationIconWidgetState extends State<AlertAnimationIconWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        padding: const EdgeInsets.all(2),
        child: Lottie.asset(
          alignment: Alignment.center,
          'assets/icons/alert_animation.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..repeat();
          },
        ),
      ),
    );
  }
}
