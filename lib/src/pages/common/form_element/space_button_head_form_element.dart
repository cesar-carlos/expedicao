import 'package:flutter/material.dart';

import 'package:app_expedicao/src/app/app_color.dart';

// ignore: must_be_immutable
class SpaceButtonsHeadFormElement extends StatelessWidget {
  double width;
  List<Widget> children;

  SpaceButtonsHeadFormElement({
    super.key,
    required this.width,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 60,
      color: AppColor.backGroundBar,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: children.map(
            (widget) {
              return Row(
                children: [
                  widget,
                  const VerticalDivider(
                    color: Colors.blueGrey,
                    indent: 3,
                    endIndent: 2,
                    thickness: 1,
                  ),
                ],
              );
            },
          ).toList()),
    );
  }
}
