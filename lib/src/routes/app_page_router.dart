import 'package:get/get.dart';

import 'package:app_expedicao/src/routes/app_router.dart';
import 'package:app_expedicao/src/pages/splash/splash_page.dart';
import 'package:app_expedicao/src/pages/login/login_binding.dart';
import 'package:app_expedicao/src/pages/notfound/notfound_page.dart';
import 'package:app_expedicao/src/pages/splash/splash_error_page.dart';
import 'package:app_expedicao/src/pages/notfound/notfound_binding.dart';
import 'package:app_expedicao/src/pages/footer/footer_page_controller.dart';
import 'package:app_expedicao/src/pages/manager_config/manager_binding.dart';
import 'package:app_expedicao/src/pages/server_config/server_config_page.dart';
import 'package:app_expedicao/src/pages/server_config/server_config_binding.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/pages/api_config/api_config_binding.dart';
import 'package:app_expedicao/src/pages/manager_config/manager_page.dart';
import 'package:app_expedicao/src/pages/api_config/api_config_page.dart';
import 'package:app_expedicao/src/pages/conferir/conferir_binding.dart';
import 'package:app_expedicao/src/pages/conferir/conferir_page.dart';
import 'package:app_expedicao/src/pages/separar/separar_binding.dart';
import 'package:app_expedicao/src/pages/splash/splash_binding.dart';
import 'package:app_expedicao/src/pages/separar/separar_page.dart';
import 'package:app_expedicao/src/pages/login/login_page.dart';

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
        page: () => SplashErrorPage(detail: Get.arguments)),
    GetPage(
      name: AppRouter.login,
      binding: LoginBinding(),
      transition: Transition.fadeIn,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: AppRouter.serverConfig,
      binding: ServerConfigBinding(),
      transition: Transition.fadeIn,
      page: () => const ServerConfigPage(),
    ),
    GetPage(
      name: AppRouter.apiConfig,
      binding: ApiConfigBinding(),
      transition: Transition.fadeIn,
      page: () => const ApiConfigPage(),
    ),
    GetPage(
      name: AppRouter.manager,
      binding: ManagerBinding(),
      transition: Transition.fadeIn,
      page: () => const ManagerPage(),
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
      name: AppRouter.conferir,
      binding: ConferirBinding(),
      transition: Transition.fadeIn,
      page: () {
        ExpedicaoConferirConsultaModel conferirConsulta = Get.arguments;

        Get.put(FooterPageController());
        Get.put(conferirConsulta);
        return const ConferirPage();
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
