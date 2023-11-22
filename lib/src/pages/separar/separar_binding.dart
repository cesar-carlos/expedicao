import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';
import 'package:app_expedicao/src/pages/separar/separar_controller.dart';

class SepararBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SepararController());
    Get.lazyPut(() => SepararGridController());
  }
}
