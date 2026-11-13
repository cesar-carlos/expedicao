import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:app_expedicao/src/app/app_theme.dart';
import 'package:app_expedicao/src/app/app_client_http.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/pages/window.config/window_manager_config.dart';
import 'package:app_expedicao/src/routes/app_page_router.dart';
import 'package:app_expedicao/src/routes/app_router.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/app/app_event_state.dart';
import 'package:app_expedicao/src/app/servidor_emergencia_service.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowManagerConfig().config();
  runApp(MyApp(args: args));
  await dotenv.load();
}

class MyApp extends StatefulWidget {
  final List<String> args;
  const MyApp({super.key, required this.args});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    if (widget.args.isNotEmpty) {
      final executavel =
          ProcessoExecutavelModel.fromBase64(widget.args.join(''));

      Get.put(executavel, permanent: true);
    }

    Get.put(AppClientHttp(), permanent: true);
    Get.put(AppSocketConfig(), permanent: true);
    Get.put(AppEventState(), permanent: true);
    Get.put(ServidorEmergenciaService(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Expedição de Estoque',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouter.splash,
      getPages: AppPageRouter.pages,
      theme: AppTheme.classicTheme,
    );
  }
}
