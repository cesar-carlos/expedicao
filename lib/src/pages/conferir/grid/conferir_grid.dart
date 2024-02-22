import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_theme.dart';
import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_controller.dart';
import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_columns.dart';
import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_source.dart';
import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_footer.dart';
import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_event.dart';

class ConferirGrid extends StatelessWidget {
  const ConferirGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConferirGridController>(
      //tag: ConferirGridController.gridName,
      builder: (controller) {
        return SfDataGridTheme(
          data: ConferirGridTheme().theme,
          child: SfDataGrid(
            columnWidthMode: ColumnWidthMode.fill,
            controller: controller.dataGridController,
            source: ConferirSource(controller.itensSort),
            onCellDoubleTap: ConferirGridEvent().onCellDoubleTap,
            onSelectionChanged: ConferirGridEvent().onSelectionChanged,
            columns: ConferirGridColumns().columns,
            selectionMode: SelectionMode.single,
            footer: const ConferirGridFooter(),
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
