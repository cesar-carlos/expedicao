import 'package:get/get.dart';

import 'package:app_expedicao/src/pages/notfound/notfound_page.dart';
import 'package:app_expedicao/src/pages/notfound/notfound_binding.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
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
      name: AppRouter.separar,
      binding: SepararBinding(),
      transition: Transition.fadeIn,
      page: () {
        ProcessoExecutavelModel processos = Get.arguments['processoExecutavel'];
        ExpedicaoSepararConsultaModel separa = Get.arguments['separarConsulta'];

        return SepararPage(
          processoExecutavel: processos,
          separarConsulta: separa,
        );
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
