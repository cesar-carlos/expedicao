import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/notfound/notfound_page.dart';
import 'package:app_expedicao/src/pages/splash/splash_error_page.dart';
import 'package:app_expedicao/src/pages/notfound/notfound_binding.dart';
import 'package:app_expedicao/src/pages/footer/footer_page_controller.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/pages/separar/separar_controller.dart';
import 'package:app_expedicao/src/pages/separar/separar_binding.dart';
import 'package:app_expedicao/src/pages/splash/splash_binding.dart';
import 'package:app_expedicao/src/pages/separar/separar_page.dart';
import 'package:app_expedicao/src/pages/splash/splash_page.dart';
import 'package:app_expedicao/src/routes/app_router.dart';

class AppPageRouter {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRouter.splash,
      binding: SplashBinding(),
      transition: Transition.fadeIn,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: AppRouter.splashError,
      transition: Transition.fadeIn,
      page: () {
        String erroCode = Get.arguments;
        return SplashErrorPage(erroCode: erroCode);
      },
    ),
    GetPage(
      name: AppRouter.separar,
      binding: SepararBinding(),
      transition: Transition.fadeIn,
      page: () {
        ExpedicaoSepararConsultaModel separarConsulta = Get.arguments;
        Get.put(separarConsulta);

        Get.put(FooterPageController());
        return SepararPage(separarConsulta: separarConsulta);
      },
    ),
    GetPage(
      name: AppRouter.notfind,
      binding: NotFoundBinding(),
      transition: Transition.fadeIn,
      page: () {
        return const NotFoundPage();
      },
    ),
  ];
}
