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
    return toIntOrNull(value);
  }

  static int tryStringToIntOrZero(String? value) {
    return toIntOrZero(value);
  }

  static int? toIntOrNull(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      return int.tryParse(trimmed);
    }
    return int.tryParse(value.toString());
  }

  static int toIntOrZero(dynamic value) => toIntOrNull(value) ?? 0;

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

  static double qtdDisplayToDouble(String value) {
    return double.parse(value.replaceAll('.', '').replaceAll(',', '.'));
  }

  static bool isBarCode(String value) {
    if (value.trim().length > 6) return true;
    if (!AppHelper.isNumeric(value.trim())) return true;

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

  static bool isNumeric(String value) {
    final numericRegex = RegExp(r'^[0-9]+$');
    return numericRegex.hasMatch(value);
  }
}
