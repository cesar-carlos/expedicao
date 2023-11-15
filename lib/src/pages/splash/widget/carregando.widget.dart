import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class CarregandoWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const CarregandoWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: SizedBox.expand(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Carregando'),
              SizedBox(
                width: 30,
                child: AnimatedTextKit(
                  isRepeatingAnimation: true,
                  repeatForever: true,
                  pause: const Duration(milliseconds: 1300),
                  animatedTexts: [
                    TyperAnimatedText('.'),
                    TyperAnimatedText('..'),
                    TyperAnimatedText('...'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
