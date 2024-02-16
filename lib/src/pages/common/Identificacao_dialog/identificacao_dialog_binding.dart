import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/common/Identificacao_dialog/identificacao_dialog_controller.dart';

class IdentificacaoDialogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IdentificacaoDialogController());
  }
}
