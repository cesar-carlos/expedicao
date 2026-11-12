import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/common/widget/loading_process_dialog_generic_widget.dart';

class LoadingProcessDialogWidget {
  static Future<void> show({
    required bool canCloseWindow,
    required BuildContext context,
    required Future<void> Function() process,
  }) {
    return LoadingProcessDialogGenericWidget.show<bool>(
      canCloseWindow: canCloseWindow,
      context: context,
      process: () async {
        await process();
        return true;
      },
    );
  }
}
