import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/common/footer_dialog/footer_dialog_controller.dart';
import 'package:app_expedicao/src/app/app_color.dart';

class FooterDialog extends StatelessWidget {
  final List<Widget> leftWidgets;
  final List<Widget> rightWidgets;

  const FooterDialog({
    super.key,
    this.leftWidgets = const [],
    this.rightWidgets = const [],
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FooterDialogController>(
      init: FooterDialogController(),
      builder: (controller) {
        return SizedBox(
          width: double.infinity,
          height: 21,
          child: DecoratedBox(
            decoration: const BoxDecoration(color: AppColor.backGroundBar),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(children: leftWidgets),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: const Image(
                    image: AssetImage('assets/images/log_white32px.png'),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: const EdgeInsets.only(right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: rightWidgets,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
