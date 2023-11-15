import 'package:date_format/date_format.dart';

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

  static stringToDouble(String value) {
    try {
      return double.parse(value);
    } catch (err) {
      return 0.0000;
    }
  }
}
