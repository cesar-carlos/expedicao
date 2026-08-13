import 'package:flutter/material.dart';

class CarrinhosAgruparGridCells {
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
        style: CarrinhosAgruparGridCells.textStyleCell(),
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
        style: CarrinhosAgruparGridCells.textStyleCell(),
      ),
    );
  }

  static Container defaultMoneyCell(double value) {
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
        style: CarrinhosAgruparGridCells.textStyleCell(),
      ),
    );
  }

  static SizedBox defaultImageCell(Image value) {
    return SizedBox(
      child: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 0.2,
          ),
        ),
        child: value,
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
