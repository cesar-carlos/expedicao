import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';

class AppHelper {
  static String formatarData(DateTime? data) {
    if (data == null) return '';
    return formatDate(data, [dd, '/', mm, '/', yyyy]);
  }

  static String formatarHora(DateTime? data) {
    if (data == null) return '';
    return formatDate(data, [HH, ':', nn, ':', ss]);
  }

  static DateTime tryStringToDate(String? date) {
    try {
      if (date == null) return DateTime(1900);
      if (date == '') return DateTime(1900);

      return DateTime.parse(date);
    } catch (err) {
      return DateTime(1900);
    }
  }

  static DateTime? tryStringToDateOrNull(String? date) {
    try {
      if (date == null) return null;
      if (date == '') return null;

      return DateTime.parse(date);
    } catch (err) {
      return null;
    }
  }

  static double stringToDouble(String? value) {
    try {
      if (value == null) return 0.0000;
      return double.parse(value);
    } catch (err) {
      return 0.0000;
    }
  }

  static int stringToInt(String? value) {
    try {
      if (value == null) return 0;
      return int.parse(value);
    } catch (err) {
      return 0;
    }
  }

  static String stringToQuantity(String? newValue) {
    try {
      if (newValue == null) return '0,000';
      final formatd = NumberTextInputFormatter(
        integerDigits: 10,
        decimalDigits: 3,
        maxValue: '1000000000.00',
        decimalSeparator: ',',
        groupDigits: 3,
        groupSeparator: '.',
        allowNegative: false,
        overrideDecimalPoint: true,
        insertDecimalPoint: false,
        insertDecimalDigits: true,
      );

      return formatd
          .formatEditUpdate(
            const TextEditingValue(
              text: '',
              selection: TextSelection.collapsed(offset: 0),
            ),
            TextEditingValue(
              text: newValue,
              selection: TextSelection.collapsed(offset: newValue.length),
            ),
          )
          .text;
    } catch (err) {
      return '0,00';
    }
  }
}
