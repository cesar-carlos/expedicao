import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/routes/app_router.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class SplashErrorWidget extends StatefulWidget {
  final String detail;
  final String? message;

  const SplashErrorWidget({
    super.key,
    required this.detail,
    this.message = '',
  });

  @override
  State<SplashErrorWidget> createState() => _ComplitAnimationIconWidgetState();
}

class _ComplitAnimationIconWidgetState extends State<SplashErrorWidget>
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
    final size = MediaQuery.of(context).size;

    return Container(
      color: Colors.blueGrey[50],
      child: Column(
        children: [
          const SizedBox(height: 100),
          SizedBox(
            width: size.width,
            height: size.height * .5,
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
          SizedBox(
            width: size.width * .8,
            child: Text(
              widget.detail,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Get.offAllNamed(AppRouter.login),
            icon: const Icon(
              BootstrapIcons.gear_fill,
            ),
          ),
        ],
      ),
    );
  }
}
