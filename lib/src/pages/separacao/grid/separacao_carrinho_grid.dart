import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_columns.dart';
import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_footer.dart';
import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_source.dart';
import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_event.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';

class SeparacaoCarrinhoGrid extends StatelessWidget {
  final ExpedicaoCarrinhoPercursoConsultaModel percursoEstagioConsulta;

  SeparacaoCarrinhoGrid(this.percursoEstagioConsulta, {super.key}) {
    Get.lazyPut(() => SeparacaoCarrinhoGridController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SeparacaoCarrinhoGridController>(builder: (controller) {
      return Obx(() => SfDataGrid(
            source: SeparacaoCarrinhoGridSource(controller.itensSort),
            columnWidthMode: ColumnWidthMode.fill,
            onCellDoubleTap: SeparacaoCarrinhoGridEvent.onCellDoubleTap,
            columns: SeparacaoCarrinhoGridColumns().columns,
            footer: SeparacaoCarrinhoGridFooter(
                codCarrinho: percursoEstagioConsulta.codCarrinho,
                item: percursoEstagioConsulta.item),
            headerRowHeight: 40,
            rowHeight: 40,
          ));
    });
  }
}
