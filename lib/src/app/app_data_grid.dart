import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

extension AppDataGridController on DataGridController {
  /// Seleciona a row e rola até ela só depois da grid estar no layout.
  ///
  /// O [scrollToRow] da SfDataGrid acessa [ScrollController.position] sem
  /// checar [ScrollController.hasClients]. No primeiro item, ou quando a
  /// grid ainda não está na árvore, isso dispara
  /// `ScrollController not attached to any scroll views`.
  void selectAndScrollToRow(
    int index, {
    bool scroll = true,
    int? rowCount,
  }) {
    if (!_isValidRowIndex(index, rowCount)) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isValidRowIndex(index, rowCount)) {
        return;
      }

      try {
        selectedIndex = index;
      } catch (_) {
        return;
      }

      if (!scroll) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isValidRowIndex(index, rowCount)) {
          return;
        }

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
        } catch (_) {
          // Grid desmontada, source trocado ou métricas de row inválidas.
        }
      });
    });
  }

  void clearSelection() {
    try {
      selectedRows.clear();
      selectedIndex = -1;
    } catch (_) {}
  }

  bool _isValidRowIndex(int index, int? rowCount) {
    if (index < 0) {
      return false;
    }

    if (rowCount != null && index >= rowCount) {
      return false;
    }

    return true;
  }
}
