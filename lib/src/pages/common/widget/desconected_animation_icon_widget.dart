import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DesconectedAnimationIconWidget extends StatefulWidget {
  const DesconectedAnimationIconWidget({super.key});

  @override
  State<DesconectedAnimationIconWidget> createState() =>
      _ComplitAnimationIconWidgetState();
}

class _ComplitAnimationIconWidgetState
    extends State<DesconectedAnimationIconWidget>
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
          'assets/icons/server_desconected_animation.json',
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
