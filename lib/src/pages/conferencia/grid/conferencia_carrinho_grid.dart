import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_theme.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_columns.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_footer.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_source.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_event.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';

class ConferenciaCarrinhoGrid extends StatefulWidget {
  final ExpedicaoCarrinhoPercursoEstagioConsultaModel percursoEstagioConsulta;

  const ConferenciaCarrinhoGrid(this.percursoEstagioConsulta, {super.key});

  @override
  State<ConferenciaCarrinhoGrid> createState() =>
      _ConferenciaCarrinhoGridState();
}

class _ConferenciaCarrinhoGridState extends State<ConferenciaCarrinhoGrid> {
  final _columns = ConferenciaCarrinhoGridColumns().columns;
  final _source = ConferenciaCarrinhoGridSource();
  late final SfDataGridThemeData _theme;

  @override
  void initState() {
    super.initState();
    _theme = ConferenciaCarrinhoGridTheme().theme;
    Get.find<ConferenciaCarrinhoGridController>().attachSource(_source);
  }

  @override
  void dispose() {
    if (Get.isRegistered<ConferenciaCarrinhoGridController>()) {
      Get.find<ConferenciaCarrinhoGridController>().detachSource(_source);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConferenciaCarrinhoGridController>();
    return SfDataGridTheme(
      data: _theme,
      child: SfDataGrid(
        columnWidthMode: ColumnWidthMode.fill,
        controller: controller.dataGridController,
        source: _source,
        onCellDoubleTap: ConferenciaCarrinhoGridEvent.onCellDoubleTap,
        columns: _columns,
        selectionMode: SelectionMode.single,
        navigationMode: GridNavigationMode.row,
        footer: ConferenciaCarrinhoGridFooter(
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
