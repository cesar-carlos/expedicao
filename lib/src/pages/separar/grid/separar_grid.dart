import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_columns.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_source.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_footer.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_event.dart';

class SepararGrid extends StatelessWidget {
  final controller = Get.find<SepararGridController>();
  SepararGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SepararGridController>(
        init: controller,
        builder: (controller) {
          return Obx(() => SfDataGrid(
                source: SepararSource(controller.itensSort),
                columnWidthMode: ColumnWidthMode.fill,
                onCellDoubleTap: SepararGridEvent.onCellDoubleTap,
                columns: SepararGridColumns().columns,
                footer: const SepararGridFooter(),
                showColumnHeaderIconOnHover: true,
                isScrollbarAlwaysShown: true,
                headerRowHeight: 40,
                rowHeight: 40,
              ));
        });
  }
}
