import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_event.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_columns.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_footer.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_source.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_controller.dart';

class SepararCarrinhoGrid extends StatelessWidget {
  final controller = Get.find<SepararCarrinhoGridController>();
  SepararCarrinhoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SepararCarrinhoGridController>(
        init: controller,
        builder: (controller) {
          return Obx(() => SfDataGrid(
                source: SepararCarrinhoGridSource(itens: controller.itens),
                columnWidthMode: ColumnWidthMode.fill,
                onCellDoubleTap: SepararCarrinhoGridEvent.onCellDoubleTap,
                columns: SepararCarrinhoGridColumns().columns,
                footer: const SepararCarrinhoGridFooter(),
                headerRowHeight: 30,
                rowHeight: 40,
              ));
        });
  }
}