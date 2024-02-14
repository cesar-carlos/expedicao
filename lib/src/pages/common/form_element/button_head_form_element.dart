import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonHeadForm extends StatelessWidget {
  Icon icon;
  String title;
  VoidCallback? onPressed;
  String? shotCut;

  ButtonHeadForm({
    super.key,
    required this.title,
    required this.icon,
    this.onPressed,
    this.shotCut,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Material(
        color: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        type: MaterialType.button,
        child: Stack(
          children: [
            IgnorePointer(
              child: Container(
                width: 120,
                height: 90,
                child: Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    shotCut?.toUpperCase() ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 120,
              height: 90,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 4, bottom: 2, left: 9, right: 5),
                child: InkWell(
                  hoverColor: Colors.white.withOpacity(0.1),
                  onTap: onPressed,
                  child: Column(
                    children: [
                      icon,
                      const SizedBox(height: 2),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
