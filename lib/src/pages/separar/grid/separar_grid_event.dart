import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';

class SepararGridEvent {
  final controller = Get.find<SepararGridController>();

  void onCellDoubleTap(DataGridCellDoubleTapDetails details) {}

  void onSelectionChanged(
    List<DataGridRow> newDataGridRows,
    List<DataGridRow> oldDataGridRows,
  ) {
    if (controller.applyingSelection) {
      return;
    }

    if (newDataGridRows.isEmpty) {
      return;
    }

    final itemCell = newDataGridRows.first.getCells().where(
          (cell) => cell.columnName == 'item',
        );
    if (itemCell.isEmpty) {
      return;
    }

    final item = itemCell.first.value?.toString();
    if (item == null || item.isEmpty) {
      return;
    }

    controller.highlightItem(item, scroll: false);
  }
}
