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

  /// Largura de `Item` / `ItemCarrinhoPercurso` no SQL (`FORMAT(..., '00000')`).
  static const int itemSequenceWidth = 5;

  /// `Item` no JSON pode vir `00006` ou `6`. Só para comparar na grade.
  static String gridItemKey(dynamic value) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty) return '';
    final asInt = int.tryParse(text);
    if (asInt == null) return text;
    return asInt.toString();
  }

  static bool sameGridItem(dynamic a, dynamic b) {
    return gridItemKey(a) == gridItemKey(b);
  }

  static bool sameBarCode(String? stored, String scanned) {
    final a = stored?.trim() ?? '';
    final b = scanned.trim();
    if (a.isEmpty || b.isEmpty) return false;
    return a == b;
  }

  /// `ConversaoUnidadeMedida.Codigo` chega como `CodigoBarras` (alias SQL) ou `Codigo`.
  static String? conversaoCodigo(Map<String, dynamic> json) {
    final value = json['CodigoBarras'] ?? json['Codigo'];
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  /// Whether [setor] is a real sector code.
  ///
  /// Only values greater than zero count. `null` and `0` mean undefined;
  /// the SQL default often arrives as `0` instead of null.
  static bool setorDefinido(int? setor) {
    return setor != null && setor > 0;
  }

  /// Whether the user may operate the item by sector.
  ///
  /// Returns true if either side is undefined (`null` or `<= 0`), or both
  /// defined codes match. Picking compares the user's `codSetorEstoque`;
  /// checking compares `codSetorConferencia`. The item side is always
  /// `codSetorEstoque`.
  static bool setorPermitido(int? setorUsuario, int? setorItem) {
    if (!setorDefinido(setorUsuario) || !setorDefinido(setorItem)) {
      return true;
    }
    return setorUsuario == setorItem;
  }

  /// Quantity to re-add from a cancelled cart without exceeding the order.
  static double quantidadeRecuperar({
    required double quantidadeCancelada,
    required double quantidadePedido,
    required double quantidadeJaSeparada,
  }) {
    final restante = quantidadePedido - quantidadeJaSeparada;
    if (restante <= 0 || quantidadeCancelada <= 0) return 0;
    return quantidadeCancelada < restante ? quantidadeCancelada : restante;
  }

  /// Chave de `Item` para `select` / `delete` / `update`. A tabela guarda
  /// `'00001'`; `gridItemKey` deixa `'1'` e o WHERE não acha a linha.
  static String itemSequenceKey(dynamic value) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty) {
      return '0'.padLeft(itemSequenceWidth, '0');
    }
    final asInt = int.tryParse(text);
    if (asInt == null) return text;
    return asInt.toString().padLeft(itemSequenceWidth, '0');
  }
}
