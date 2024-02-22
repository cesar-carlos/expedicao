import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:app_expedicao/src/pages/conferir_carrinhos/grid/conferir_carrinho_grid_theme.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/grid/conferir_carrinho_grid_event.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/grid/conferir_carrinho_grid_columns.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/grid/conferir_carrinho_grid_footer.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/grid/conferir_carrinho_grid_source.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/grid/conferir_carrinho_grid_controller.dart';

class ConferirCarrinhoGrid extends StatelessWidget {
  const ConferirCarrinhoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConferirCarrinhoGridController>(
      //tag: ConferirCarrinhoGridController.gridName,
      builder: (controller) {
        return SfDataGridTheme(
          data: ConferirCarrinhoGridTheme().theme,
          child: SfDataGrid(
            columnWidthMode: ColumnWidthMode.fill,
            controller: controller.dataGridController,
            source: ConferirCarrinhoGridSource(itens: controller.itensSort),
            onCellDoubleTap: ConferirCarrinhoGridEvent.onCellDoubleTap,
            columns: ConferirCarrinhoGridColumns().columns,
            selectionMode: SelectionMode.single,
            footer: const ConferirCarrinhoGridFooter(),
            showColumnHeaderIconOnHover: true,
            isScrollbarAlwaysShown: true,
            headerRowHeight: 41,
            rowHeight: 40,
          ),
        );
      },
    );
  }
}
