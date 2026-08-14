import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

extension AppDataGridController on DataGridController {
  /// Seleciona a row e rola até ela só depois da grid estar no layout.
  ///
  /// O [scrollToRow] da SfDataGrid acessa [ScrollController.position] sem
  /// checar [ScrollController.hasClients]. No primeiro item, ou quando a
  /// grid ainda não está na árvore, isso dispara
  /// `ScrollController not attached to any scroll views`.
  void selectAndScrollToRow(int index, {bool scroll = true}) {
    if (index < 0) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedIndex = index;
      if (!scroll) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          scrollToRow(
            index.toDouble(),
            canAnimate: true,
            position: DataGridScrollPosition.center,
          );
        } on AssertionError {
          // Debug: assert(_positions.isNotEmpty) no ScrollController.
        } on StateError {
          // Release: _positions.single com a lista vazia.
        }
      });
    });
  }
}
