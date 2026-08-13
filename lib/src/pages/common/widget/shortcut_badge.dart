import 'package:flutter/material.dart';

import 'package:app_expedicao/src/app/app_color.dart';

class ShortcutBadge extends StatelessWidget {
  const ShortcutBadge({
    super.key,
    required this.shortCut,
    required this.child,
    this.onPressed,
    this.tooltip,
  });

  final String shortCut;
  final Widget child;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final content = SizedBox(
      width: 42,
      height: 36,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          child,
          Positioned(
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColor.backGroundBar,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  shortCut,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final tappable = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: content,
      ),
    );

    if (tooltip == null || tooltip!.isEmpty) {
      return tappable;
    }

    return Tooltip(message: tooltip!, child: tappable);
  }
}
