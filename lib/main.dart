import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

import 'package:app_expedicao/src/app/app_theme.dart';
import 'package:app_expedicao/src/app/app_client_http.dart';
import 'package:app_expedicao/src/pages/splash/splash_binding.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/pages/window.config/window_manager_config.dart';
import 'package:app_expedicao/src/pages/splash/splash_page.dart';
import 'package:app_expedicao/src/routes/app_page_router.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/app/app_event_state.dart';

Future<void> main(List<String> args) async {
  if (args.isNotEmpty) {
    final _executavel = ProcessoExecutavelModel.fromBase64(args.join(''));
    Get.put(_executavel);
  }

  WidgetsFlutterBinding.ensureInitialized();
  await WindowManagerConfig().config();
  MediaKit.ensureInitialized();

  Get.put(AppClientHttp());
  Get.put(AppSocketConfig());
  Get.put(AppEventState());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Expedição de Estoque',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(body: SplashPage()),
      initialBinding: SplashBinding(),
      getPages: AppPageRouter.pages,
      theme: AppTheme.classicTheme,
    );
  }
}
