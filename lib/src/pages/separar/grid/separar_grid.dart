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

class SepararGrid extends StatefulWidget {
  const SepararGrid({
    super.key,
    this.forSeparacao = false,
  });

  final bool forSeparacao;

  @override
  State<SepararGrid> createState() => _SepararGridState();
}

class _SepararGridState extends State<SepararGrid> {
  final _columns = SepararGridColumns().columns;
  final _source = SepararSource();
  final _events = SepararGridEvent();
  late final SfDataGridThemeData _theme;

  @override
  void initState() {
    super.initState();
    _theme = SepararGridTheme().theme;
    Get.find<SepararGridController>().attachSource(_source);
  }

  @override
  void dispose() {
    if (Get.isRegistered<SepararGridController>()) {
      Get.find<SepararGridController>().detachSource(_source);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SepararGridController>();
    return SfDataGridTheme(
      data: _theme,
      child: SfDataGrid(
        columnWidthMode: ColumnWidthMode.fill,
        controller: widget.forSeparacao
            ? controller.dataGridControllerSeparacao
            : controller.dataGridController,
        source: _source,
        onCellDoubleTap: _events.onCellDoubleTap,
        onSelectionChanged: _events.onSelectionChanged,
        columns: _columns,
        selectionMode: SelectionMode.single,
        navigationMode: GridNavigationMode.row,
        footer: const SepararGridFooter(),
        highlightRowOnHover: false,
        showColumnHeaderIconOnHover: true,
        isScrollbarAlwaysShown: true,
        headerRowHeight: 40,
        rowHeight: 40,
      ),
    );
  }
}
