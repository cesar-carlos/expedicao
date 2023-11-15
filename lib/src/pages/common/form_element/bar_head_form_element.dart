import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BarHeadFormElement extends StatefulWidget {
  String title;
  double widthBar;
  double heightBar = 30;
  VoidCallback? onPressedCloseBar;
  Color colorCloseBar = Colors.transparent;
  Color colorCloseBarHover = const Color.fromARGB(255, 212, 56, 44);

  BarHeadFormElement({
    super.key,
    required this.widthBar,
    required this.title,
    this.onPressedCloseBar,
  });

  @override
  State<BarHeadFormElement> createState() => _BarHeadFormElementState();
}

class _BarHeadFormElementState extends State<BarHeadFormElement> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      child: Container(
        width: widget.widthBar,
        height: widget.heightBar,
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          color: Theme.of(context).tabBarTheme.indicatorColor,
        ),
        child: Row(
          children: [
            const Image(
              width: 18,
              image: AssetImage('assets/images/log_black_icon.png'),
            ),
            const SizedBox(width: 5),
            Text(widget.title),
            const Spacer(),
            Container(
              width: 43,
              height: 33,
              padding: const EdgeInsets.only(bottom: 0.7),
              child: Material(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                ),
                color: widget.colorCloseBar,
                child: InkWell(
                  onTap: () {
                    if (widget.onPressedCloseBar != null) {
                      widget.onPressedCloseBar!();
                    }

                    Navigator.of(context).pop();
                  },
                  onHover: (value) => setState(
                    () {
                      if (value) {
                        widget.colorCloseBar = widget.colorCloseBarHover;
                      } else {
                        widget.colorCloseBar = Colors.transparent;
                      }
                    },
                  ),
                  child: Icon(
                    Icons.close,
                    color: Theme.of(context).tabBarTheme.indicatorColor,
                    size: 20,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
