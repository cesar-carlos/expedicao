import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:app_expedicao/src/pages/carrinho_agrupar/grid/carrinhos_agrupar_grid_controller.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar/grid/carrinhos_agrupar_grid_columns.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar/grid/carrinhos_agrupar_grid_event.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar/grid/carrinhos_agrupar_grid_source.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar/grid/carrinhos_agrupar_grid_theme.dart';

class CarrinhosAgruparGrid extends StatelessWidget {
  const CarrinhosAgruparGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CarrinhosAgruparGridController>(
      builder: (controller) {
        return SfDataGridTheme(
          data: CarrinhosAgruparGridTheme().theme,
          child: SfDataGrid(
            columnWidthMode: ColumnWidthMode.fill,
            controller: controller.dataGridController,
            source: CarrinhosAgruparGridSource(itens: controller.itens),
            onCellDoubleTap: CarrinhosAgruparGridEvent.onCellDoubleTap,
            columns: CarrinhosAgruparGridColumns().columns,
            selectionMode: SelectionMode.single,
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
