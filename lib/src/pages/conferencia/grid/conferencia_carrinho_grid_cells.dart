import 'package:flutter/material.dart';

import 'package:app_expedicao/src/app/app_color.dart';
import 'package:app_expedicao/src/app/app_helper.dart';

class ConferenciaCarrinhoGridCells {
  static Widget withFocusBorder(
    Widget child, {
    required bool focused,
    required bool isFirst,
    required bool isLast,
  }) {
    if (!focused) {
      return child;
    }

    const side = BorderSide(color: AppColor.backGroundBar, width: 2);
    return Container(
      foregroundDecoration: BoxDecoration(
        border: Border(
          top: side,
          bottom: side,
          left: isFirst ? side : BorderSide.none,
          right: isLast ? side : BorderSide.none,
        ),
      ),
      child: child,
    );
  }

  static TextStyle textStyleCell() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 12,
    );
  }

  static Container defaultCells<T>(T value, {alignment = Alignment.centerLeft}) {
    return Container(
      padding: const EdgeInsets.all(2),
      alignment: alignment,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.2,
        ),
      ),
      child: Text(
        value == null ? '' : value.toString(),
        style: ConferenciaCarrinhoGridCells.textStyleCell(),
      ),
    );
  }

  static Container defaultIntCell(int value) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.2,
        ),
      ),
      child: Text(
        value.toString(),
        style: ConferenciaCarrinhoGridCells.textStyleCell(),
      ),
    );
  }

  static Container defaultMoneyCell(double value) {
    final display = value.toStringAsFixed(3).replaceAll('.', ',');

    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.2,
        ),
      ),
      child: Text(
        AppHelper.stringToQuantity(display),
        style: ConferenciaCarrinhoGridCells.textStyleCell(),
      ),
    );
  }

  static SizedBox defaultWidgetCell(Widget value) {
    return SizedBox(
      child: Container(
        child: value,
      ),
    );
  }
}
