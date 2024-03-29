import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:app_expedicao/src/app/app_color.dart';

class ConferirCarrinhoGridTheme {
  SfDataGridThemeData get theme {
    return SfDataGridThemeData(
      brightness: Brightness.light,
      rowHoverColor: Theme.of(Get.context!).primaryColor.withOpacity(0.1),
      selectionColor: AppColor.gridRowSelectedRowColor,
    );
  }
}
