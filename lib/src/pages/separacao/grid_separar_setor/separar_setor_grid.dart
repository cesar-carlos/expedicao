import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:app_expedicao/src/pages/separacao/grid_separar_setor/separar_setor_grid_columns.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separar_setor/separar_setor_grid_controller.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separar_setor/separar_setor_grid_event.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separar_setor/separar_setor_grid_footer.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separar_setor/separar_setor_grid_source.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separar_setor/separar_setor_grid_theme.dart';

// ignore: must_be_immutable
class SepararSetorGrid extends StatelessWidget {
  const SepararSetorGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SepararSetorGridController>(
      builder: (controller) {
        return SfDataGridTheme(
          data: SepararSetorGridTheme.theme,
          child: SfDataGrid(
            columnWidthMode: ColumnWidthMode.fill,
            controller: controller.dataGridController,
            source: SepararSetorSource(controller.itensSort),
            onCellDoubleTap: SepararSetorGridEvent.onCellDoubleTap,
            columns: SepararSetorGridColumns().columns,
            selectionMode: SelectionMode.single,
            footer: const SepararSetorGridFooter(),
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
