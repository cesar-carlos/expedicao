import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_theme.dart';
import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_controller.dart';
import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_columns.dart';
import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_source.dart';
import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_footer.dart';
import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_event.dart';

class ConferirGrid extends StatefulWidget {
  const ConferirGrid({
    super.key,
    this.forConferencia = false,
  });

  final bool forConferencia;

  @override
  State<ConferirGrid> createState() => _ConferirGridState();
}

class _ConferirGridState extends State<ConferirGrid> {
  final _columns = ConferirGridColumns().columns;
  final _source = ConferirSource();
  final _events = ConferirGridEvent();
  late final SfDataGridThemeData _theme;

  @override
  void initState() {
    super.initState();
    _theme = ConferirGridTheme().theme;
    Get.find<ConferirGridController>().attachSource(_source);
  }

  @override
  void dispose() {
    if (Get.isRegistered<ConferirGridController>()) {
      Get.find<ConferirGridController>().detachSource(_source);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConferirGridController>();
    return SfDataGridTheme(
      data: _theme,
      child: SfDataGrid(
        columnWidthMode: ColumnWidthMode.fill,
        controller: widget.forConferencia
            ? controller.dataGridControllerConferencia
            : controller.dataGridController,
        source: _source,
        onCellDoubleTap: _events.onCellDoubleTap,
        onSelectionChanged: _events.onSelectionChanged,
        columns: _columns,
        selectionMode: controller.selectionMode
            ? SelectionMode.single
            : SelectionMode.none,
        navigationMode: GridNavigationMode.row,
        footer: const ConferirGridFooter(),
        highlightRowOnHover: false,
        showColumnHeaderIconOnHover: true,
        isScrollbarAlwaysShown: true,
        headerRowHeight: 40,
        rowHeight: 40,
      ),
    );
  }
}
