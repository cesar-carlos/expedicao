import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/pages/conferido_carrinhos/grid/conferido_carrinho_grid_controller.dart';

class ConferidoCarrinhoGridEvent {
  static void onCellDoubleTap(DataGridCellDoubleTapDetails details) {}

  static void onSelectionChanged(
    List<DataGridRow> newDataGridRows,
    List<DataGridRow> oldDataGridRows,
  ) {
    if (!Get.isRegistered<ConferidoCarrinhoGridController>()) {
      return;
    }

    final controller = Get.find<ConferidoCarrinhoGridController>();
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
