import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:app_expedicao/src/app/app_color.dart';

class SeparadoCarrinhoGridTheme {
  SfDataGridThemeData get theme {
    return SfDataGridThemeData.raw(
      gridLineStrokeWidth: 1,
      brightness: Brightness.dark,
      rowHoverColor: Colors.transparent,
      selectionColor: AppColor.gridRowSelectedRowColor,
    );
  }
}
