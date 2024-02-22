import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SepararGridEvent {
  final controller = Get.find<SepararGridController>();

  onCellDoubleTap(value) {}

  onSelectionChanged(
    List<DataGridRow> newDataGridRows,
    List<DataGridRow> oldDataGridRows,
  ) {}
}
