import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';

class SepararGridTheme {
  final controller = Get.find<SepararGridController>();

  SfDataGridThemeData get theme {
    return SfDataGridThemeData(
      brightness: Brightness.light,
      rowHoverColor: Theme.of(Get.context!).primaryColor.withOpacity(0.1),
      selectionColor: controller.selectedRowColor,
    );
  }
}
