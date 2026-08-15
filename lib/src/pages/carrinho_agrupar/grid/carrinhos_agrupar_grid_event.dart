import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/pages/carrinho_agrupar/grid/carrinhos_agrupar_grid_controller.dart';

class CarrinhosAgruparGridEvent {
  static void onCellDoubleTap(DataGridCellDoubleTapDetails details) {}

  static void onSelectionChanged(
    List<DataGridRow> newDataGridRows,
    List<DataGridRow> oldDataGridRows,
  ) {
    if (!Get.isRegistered<CarrinhosAgruparGridController>()) {
      return;
    }

    final controller = Get.find<CarrinhosAgruparGridController>();
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
