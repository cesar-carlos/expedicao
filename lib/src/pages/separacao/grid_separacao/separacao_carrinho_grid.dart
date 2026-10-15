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

class SeparacaoCarrinhoGrid extends StatefulWidget {
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;

  const SeparacaoCarrinhoGrid(this.percursoEstagioConsulta, {super.key});

  @override
  State<SeparacaoCarrinhoGrid> createState() => _SeparacaoCarrinhoGridState();
}

class _SeparacaoCarrinhoGridState extends State<SeparacaoCarrinhoGrid> {
  final _columns = SeparacaoCarrinhoGridColumns().columns;
  final _source = SeparacaoCarrinhoGridSource();
  late final SfDataGridThemeData _theme;

  @override
  void initState() {
    super.initState();
    _theme = SeparacaoCarrinhoGridTheme().theme;
    Get.find<SeparacaoCarrinhoGridController>().attachSource(_source);
  }

  @override
  void dispose() {
    if (Get.isRegistered<SeparacaoCarrinhoGridController>()) {
      Get.find<SeparacaoCarrinhoGridController>().detachSource(_source);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SeparacaoCarrinhoGridController>();
    return SfDataGridTheme(
      data: _theme,
      child: SfDataGrid(
        columnWidthMode: ColumnWidthMode.fill,
        controller: controller.dataGridController,
        source: _source,
        onCellDoubleTap: SeparacaoCarrinhoGridEvent.onCellDoubleTap,
        columns: _columns,
        selectionMode: SelectionMode.single,
        navigationMode: GridNavigationMode.row,
        footer: SeparacaoCarrinhoGridFooter(
          codCarrinho: widget.percursoEstagioConsulta.codCarrinho,
          item: widget.percursoEstagioConsulta.item,
        ),
        highlightRowOnHover: false,
        showColumnHeaderIconOnHover: true,
        isScrollbarAlwaysShown: true,
        headerRowHeight: 40,
        rowHeight: 40,
      ),
    );
  }
}
