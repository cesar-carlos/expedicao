import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_core/theme.dart';
import 'package:app_expedicao/src/app/app_color.dart';

class ConferenciaCarrinhoGridTheme {
  SfDataGridThemeData get theme {
    return SfDataGridThemeData.raw(
      gridLineStrokeWidth: 1,
      brightness: Brightness.dark,
      rowHoverColor: Theme.of(Get.context!).primaryColor.withOpacity(0.3),
      selectionColor: AppColor.gridRowSelectedRowColor,
    );
  }
}
