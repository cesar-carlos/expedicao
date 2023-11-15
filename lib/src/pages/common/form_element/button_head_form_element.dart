import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonHeadForm extends StatelessWidget {
  Icon icon;
  String title;
  VoidCallback? onPressed;

  ButtonHeadForm({
    super.key,
    required this.title,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 120,
          height: 90,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 4, bottom: 2, left: 9, right: 5),
            child: InkWell(
              onTap: onPressed,
              child: Column(
                children: [
                  icon,
                  const SizedBox(height: 2),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
