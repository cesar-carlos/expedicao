import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:app_expedicao/src/pages/separacao/grid_separacao/separacao_carrinho_grid_theme.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separacao/separacao_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separacao/separacao_carrinho_grid_columns.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separacao/separacao_carrinho_grid_footer.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separacao/separacao_carrinho_grid_source.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separacao/separacao_carrinho_grid_event.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';

class SeparacaoCarrinhoGrid extends StatelessWidget {
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;
  const SeparacaoCarrinhoGrid(this.percursoEstagioConsulta, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SeparacaoCarrinhoGridController>(
      builder: (controller) {
        return SfDataGridTheme(
          data: SeparacaoCarrinhoGridTheme().theme,
          child: SfDataGrid(
            columnWidthMode: ColumnWidthMode.fill,
            controller: controller.dataGridController,
            source: SeparacaoCarrinhoGridSource(controller.itensSort),
            onCellDoubleTap: SeparacaoCarrinhoGridEvent.onCellDoubleTap,
            columns: SeparacaoCarrinhoGridColumns().columns,
            selectionMode: SelectionMode.single,
            footer: SeparacaoCarrinhoGridFooter(
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
