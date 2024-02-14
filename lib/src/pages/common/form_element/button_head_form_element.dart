import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonHeadForm extends StatelessWidget {
  Icon icon;
  String title;
  VoidCallback? onPressed;
  String? shortCut;
  bool shortCutActive;
  Color shortCutColor = Colors.white;

  ButtonHeadForm({
    super.key,
    required this.title,
    required this.icon,
    this.onPressed,
    this.shortCut,
    this.shortCutActive = true,
  }) {
    if (shortCutActive) {
      shortCutColor = Colors.white;
    } else {
      shortCutColor = Colors.red;
    }
  }

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
                  padding: const EdgeInsets.only(top: 5),
                  child: Stack(
                    children: [
                      if (shortCut != null)
                        Container(
                          padding: const EdgeInsets.only(right: 6),
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: shortCutColor.withOpacity(0.50),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              shortCut ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 120,
              height: 90,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 5, bottom: 2, left: 3, right: 3),
                child: InkWell(
                  hoverColor: Colors.white.withOpacity(0.1),
                  onTap: onPressed,
                  child: Column(
                    children: [
                      icon,
                      const SizedBox(height: 4),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
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
