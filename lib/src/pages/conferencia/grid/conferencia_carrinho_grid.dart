import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_theme.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_columns.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_footer.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_source.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_event.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';

class ConferenciaCarrinhoGrid extends StatelessWidget {
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;
  const ConferenciaCarrinhoGrid(this.percursoEstagioConsulta, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConferenciaCarrinhoGridController>(
      //tag: ConferenciaCarrinhoGridController.gridName,
      builder: (controller) {
        return SfDataGridTheme(
          data: ConferenciaCarrinhoGridTheme.theme,
          child: SfDataGrid(
            columnWidthMode: ColumnWidthMode.fill,
            controller: controller.dataGridController,
            source: ConferenciaCarrinhoGridSource(controller.itensSort),
            onCellDoubleTap: ConferenciaCarrinhoGridEvent.onCellDoubleTap,
            columns: ConferenciaCarrinhoGridColumns().columns,
            selectionMode: SelectionMode.none,
            footer: ConferenciaCarrinhoGridFooter(
              codCarrinho: percursoEstagioConsulta.codCarrinho,
              item: percursoEstagioConsulta.item,
            ),
            showColumnHeaderIconOnHover: true,
            isScrollbarAlwaysShown: true,
            headerRowHeight: 40,
            rowHeight: 40,
          ),
        );
      },
    );
  }
}
