import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:system_theme/system_theme.dart';

import 'package:app_expedicao/src/app/app_theme.dart';
import 'package:app_expedicao/src/app/app_client_http.dart';
import 'package:app_expedicao/src/pages/splash/splash_binding.dart';
import 'package:app_expedicao/src/pages/window.config/window_manager_config.dart';
import 'package:app_expedicao/src/pages/splash/splash_page.dart';
import 'package:app_expedicao/src/routes/app_page_router.dart';
import 'package:app_expedicao/src/app/app_socket.config.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowManagerConfig().config();
  await SystemTheme.accentColor.load();

  Get.put(AppClientHttp());
  Get.put(AppSocketConfig());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Separação de Estoque',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(body: SplashPage()),
      initialBinding: SplashBinding(),
      getPages: AppPageRouter.pages,
      theme: AppTheme.classicTheme,
    );
  }
}
