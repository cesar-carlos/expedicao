import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProgressAnimationIconWidget extends StatefulWidget {
  const ProgressAnimationIconWidget({super.key});

  @override
  State<ProgressAnimationIconWidget> createState() =>
      _ProgressAnimationIconWidgetState();
}

class _ProgressAnimationIconWidgetState
    extends State<ProgressAnimationIconWidget> with TickerProviderStateMixin {
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
          'assets/icons/progress_animation.json',
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
