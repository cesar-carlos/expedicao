import 'package:get/get.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

class SepararGridTheme {
  static SfDataGridThemeData get theme {
    return SfDataGridThemeData(
      brightness: Brightness.light,
      rowHoverColor: Theme.of(Get.context!).primaryColor.withOpacity(0.1),
      selectionColor: Theme.of(Get.context!).primaryColor.withOpacity(0.1),
    );
  }
}
