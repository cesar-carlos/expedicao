import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:app_expedicao/src/pages/conferido_carrinhos/grid/conferido_carrinho_grid_columns.dart';
import 'package:app_expedicao/src/pages/conferido_carrinhos/grid/conferido_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/conferido_carrinhos/grid/conferido_carrinho_grid_event.dart';
import 'package:app_expedicao/src/pages/conferido_carrinhos/grid/conferido_carrinho_grid_footer.dart';
import 'package:app_expedicao/src/pages/conferido_carrinhos/grid/conferido_carrinho_grid_source.dart';
import 'package:app_expedicao/src/pages/conferido_carrinhos/grid/conferido_carrinho_grid_theme.dart';

class ConferidoCarrinhoGrid extends StatelessWidget {
  const ConferidoCarrinhoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConferidoCarrinhoGridController>(
      //tag: ConferidoCarrinhoGridController.gridName,
      builder: (controller) {
        return SfDataGridTheme(
          data: ConferidoCarrinhoGridTheme.theme,
          child: SfDataGrid(
            columnWidthMode: ColumnWidthMode.fill,
            controller: controller.dataGridController,
            source: ConferidoCarrinhoGridSource(itens: controller.itensSort),
            onCellDoubleTap: ConferidoCarrinhoGridEvent.onCellDoubleTap,
            columns: ConferidoCarrinhoGridColumns().columns,
            selectionMode: SelectionMode.none,
            footer: const ConferidoCarrinhoGridFooter(),
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
