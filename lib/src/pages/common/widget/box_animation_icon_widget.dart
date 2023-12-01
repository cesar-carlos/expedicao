import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BoxAnimationIconWidget extends StatefulWidget {
  const BoxAnimationIconWidget({super.key});

  @override
  State<BoxAnimationIconWidget> createState() =>
      _ComplitAnimationIconWidgetState();
}

class _ComplitAnimationIconWidgetState extends State<BoxAnimationIconWidget>
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
          'assets/icons/box_animation.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward()
              ..repeat();
          },
        ),
      ),
    );
  }
}
