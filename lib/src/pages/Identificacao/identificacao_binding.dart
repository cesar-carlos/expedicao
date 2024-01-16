import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/Identificacao/Identificacao_controller.dart';

class IdentificacaoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IdentificacaoController());
  }
}
