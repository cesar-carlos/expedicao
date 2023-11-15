import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/splash/splash_controller.dart';
import 'package:app_expedicao/src/pages/footer/footer_page_controller.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
    Get.put<FooterPageController>(FooterPageController());
  }
}
