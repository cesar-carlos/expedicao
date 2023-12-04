import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_theme.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_event.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_columns.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_footer.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_source.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_controller.dart';

class SepararCarrinhoGrid extends StatelessWidget {
  const SepararCarrinhoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SepararCarrinhoGridController>(
      //tag: SepararCarrinhoGridController.gridName,
      builder: (controller) {
        return SfDataGridTheme(
          data: SepararCarrinhoGridTheme.theme,
          child: SfDataGrid(
            columnWidthMode: ColumnWidthMode.fill,
            controller: controller.dataGridController,
            source: SepararCarrinhoGridSource(itens: controller.itensSort),
            onCellDoubleTap: SepararCarrinhoGridEvent.onCellDoubleTap,
            columns: SepararCarrinhoGridColumns().columns,
            selectionMode: SelectionMode.none,
            footer: const SepararCarrinhoGridFooter(),
            showColumnHeaderIconOnHover: true,
            isScrollbarAlwaysShown: true,
            headerRowHeight: 30,
            rowHeight: 40,
          ),
        );
      },
    );
  }
}
