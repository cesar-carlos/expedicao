import 'package:app_expedicao/src/app/app_helper.dart';
import 'package:flutter/material.dart';

class SeparacaoCarrinhoGridCells {
  static textStyleCell() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 12,
    );
  }

  static defaultCells<T>(T value, {alignment = Alignment.centerLeft}) {
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
        style: SeparacaoCarrinhoGridCells.textStyleCell(),
      ),
    );
  }

  static defaultIntCell(int value) {
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
        style: SeparacaoCarrinhoGridCells.textStyleCell(),
      ),
    );
  }

  static defaultMoneyCell(double value) {
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
        style: SeparacaoCarrinhoGridCells.textStyleCell(),
      ),
    );
  }

  static defaultWidgetCell(Widget value) {
    return SizedBox(
      child: Container(
        child: value,
      ),
    );
  }
}
