import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_columns.dart';
import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_event.dart';
import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_footer.dart';
import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_source.dart';

class SeparacaoCarrinhoGrid extends StatelessWidget {
  final controller = Get.find<SeparacaoCarrinhoGridController>();
  final String item;
  final int codCarrinho;

  SeparacaoCarrinhoGrid({
    super.key,
    required this.item,
    required this.codCarrinho,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SeparacaoCarrinhoGridController>(
        init: controller,
        builder: (controller) {
          return Obx(() => SfDataGrid(
                source: SeparacaoCarrinhoGridSource(controller.itensCarrinho(
                    item: item, codCarrinho: codCarrinho)),
                columnWidthMode: ColumnWidthMode.fill,
                onCellDoubleTap: SeparacaoCarrinhoGridEvent.onCellDoubleTap,
                columns: SeparacaoCarrinhoGridColumns().columns,
                footer: SeparacaoCarrinhoGridFooter(
                    codCarrinho: codCarrinho, item: item),
                headerRowHeight: 40,
                rowHeight: 40,
              ));
        });
  }
}
