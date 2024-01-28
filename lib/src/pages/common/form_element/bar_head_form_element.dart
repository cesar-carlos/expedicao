import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

// ignore: must_be_immutable
class BarHeadFormElement extends StatefulWidget {
  String title;
  double widthBar;
  double heightBar = 30;
  VoidCallback onPressedCloseBar;
  Color colorCloseBar = Colors.transparent;
  Color colorCloseBarHover = const Color.fromARGB(255, 212, 56, 44);

  BarHeadFormElement({
    super.key,
    required this.widthBar,
    required this.onPressedCloseBar,
    required this.title,
  });

  @override
  State<BarHeadFormElement> createState() => _BarHeadFormElementState();
}

class _BarHeadFormElementState extends State<BarHeadFormElement> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onPanDown: (_) => windowManager.startDragging(),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10)),
            child: Container(
              width: widget.widthBar - 123,
              height: widget.heightBar,
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).tabBarTheme.indicatorColor,
              ),
              child: Row(
                children: [
                  const Image(
                    width: 20,
                    image: AssetImage('assets/images/log_black_icon.png'),
                  ),
                  const SizedBox(width: 5),
                  Text(widget.title),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: const BorderRadius.only(topRight: Radius.circular(10)),
          child: Container(
            width: 43,
            height: widget.heightBar,
            color: Theme.of(context).tabBarTheme.indicatorColor,
            child: Material(
              color: widget.colorCloseBar,
              child: InkWell(
                onTap: widget.onPressedCloseBar,
                onHover: (value) {
                  return setState(
                    () {
                      if (value) {
                        widget.colorCloseBar = widget.colorCloseBarHover;
                      } else {
                        widget.colorCloseBar = Colors.transparent;
                      }
                    },
                  );
                },
                child: Icon(
                  Icons.close,
                  color: Theme.of(context).tabBarTheme.indicatorColor,
                  size: 20,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
