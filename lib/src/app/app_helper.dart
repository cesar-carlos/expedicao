import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';

class AppHelper {
  static String capitalize(String text) {
    if (text.isEmpty) {
      return text;
    }

    return text[0].toUpperCase() + text.substring(1);
  }

  static String formatarData(DateTime? value) {
    if (value == null) return '';
    return formatDate(value, [dd, '/', mm, '/', yyyy]);
  }

  static String formatarHora(DateTime? value) {
    if (value == null) return '';
    return formatDate(value, [HH, ':', nn, ':', ss]);
  }

  static DateTime tryStringToDate(String? value) {
    try {
      if (value == null) return DateTime(1900);
      if (value == '') return DateTime(1900);

      return DateTime.parse(value);
    } catch (err) {
      return DateTime(1900);
    }
  }

  static DateTime? tryStringToDateOrNull(String? value) {
    try {
      if (value == null) return null;
      if (value == '') return null;

      return DateTime.parse(value);
    } catch (err) {
      return null;
    }
  }

  static int? tryStringToIntOrNull(String? value) {
    try {
      if (value == null) return null;
      if (value == '') return null;

      return int.parse(value);
    } catch (err) {
      return null;
    }
  }

  static int tryStringToIntOrZero(String? value) {
    try {
      if (value == null) return 0;
      if (value == '') return 0;

      return int.parse(value);
    } catch (err) {
      return 0;
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

  static qtdDisplayToDouble(String value) {
    return double.parse(value.replaceAll('.', '').replaceAll(',', '.'));
  }

  static isBarCode(String value) {
    if (value.trim().length > 7) return true;
    return false;
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
