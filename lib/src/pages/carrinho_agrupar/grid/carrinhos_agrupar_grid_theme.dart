import 'package:app_expedicao/src/app/app_color.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

class CarrinhosAgruparGridTheme {
  static SfDataGridThemeData get theme => SfDataGridThemeData(
        rowHoverColor: Theme.of(Get.context!).primaryColor.withOpacity(0.4),
        headerColor: AppColor.backgroundColor,
      );
}
