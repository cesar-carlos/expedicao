import 'package:get/get.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

class ConferidoCarrinhoGridTheme {
  static SfDataGridThemeData get theme => SfDataGridThemeData(
        rowHoverColor: Theme.of(Get.context!).primaryColor.withOpacity(0.4),
      );
}
