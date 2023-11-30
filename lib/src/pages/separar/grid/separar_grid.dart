import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:syncfusion_flutter_core/theme.dart';

import 'package:app_expedicao/src/pages/separar/grid/separar_grid_theme.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_columns.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_source.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_footer.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_event.dart';

class SepararGrid extends StatelessWidget {
  const SepararGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SepararGridController>(builder: (controller) {
      return Obx(
        () => SfDataGridTheme(
          data: SepararGridTheme.theme,
          child: SfDataGrid(
            columnWidthMode: ColumnWidthMode.fill,
            controller: controller.dataGridController,
            source: SepararSource(controller.itensSort),
            onCellDoubleTap: SepararGridEvent.onCellDoubleTap,
            columns: SepararGridColumns().columns,
            selectionMode: SelectionMode.single,
            footer: const SepararGridFooter(),
            showColumnHeaderIconOnHover: true,
            isScrollbarAlwaysShown: true,
            headerRowHeight: 40,
            rowHeight: 40,
          ),
        ),
      );
    });
  }
}
