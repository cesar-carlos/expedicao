import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:app_expedicao/src/pages/separarado_carrinhos/grid/separarado_carrinho_grid_columns.dart';
import 'package:app_expedicao/src/pages/separarado_carrinhos/grid/separarado_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/separarado_carrinhos/grid/separarado_carrinho_grid_event.dart';
import 'package:app_expedicao/src/pages/separarado_carrinhos/grid/separarado_carrinho_grid_footer.dart';
import 'package:app_expedicao/src/pages/separarado_carrinhos/grid/separarado_carrinho_grid_source.dart';
import 'package:app_expedicao/src/pages/separarado_carrinhos/grid/separarado_carrinho_grid_theme.dart';

class SeparadoCarrinhoGrid extends StatelessWidget {
  const SeparadoCarrinhoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SeparadoCarrinhoGridController>(
      //tag: SeparadoCarrinhoGridController.gridName,
      builder: (controller) {
        return SfDataGridTheme(
          data: SeparadoCarrinhoGridTheme.theme,
          child: SfDataGrid(
            columnWidthMode: ColumnWidthMode.fill,
            controller: controller.dataGridController,
            source: SeparadoCarrinhoGridSource(itens: controller.itensSort),
            onCellDoubleTap: SeparadoCarrinhoGridEvent.onCellDoubleTap,
            columns: SeparadoCarrinhoGridColumns().columns,
            selectionMode: SelectionMode.none,
            footer: const SeparadoCarrinhoGridFooter(),
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
