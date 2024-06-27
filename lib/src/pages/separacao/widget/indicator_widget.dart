import 'package:flutter/material.dart';

class IndicatorWidget extends StatelessWidget {
  final Size size;
  final _height = 25.0;
  final Color indicatorColor;
  final String indicatorText;

  const IndicatorWidget({
    super.key,
    required this.size,
    required this.indicatorColor,
    required this.indicatorText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      width: size.width,
      child: Container(
        alignment: Alignment.center,
        color: indicatorColor,
        child: Text(
          indicatorText,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
