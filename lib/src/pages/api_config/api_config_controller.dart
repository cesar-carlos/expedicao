import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/app/app_client_http.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/app/app_Api_file_init.dart';
import 'package:app_expedicao/src/pages/common/widget/message_dialog_widget.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_process_dialog_generic_widget.dart';
import 'package:app_expedicao/src/model/api_server_model.dart';
import 'package:app_expedicao/src/routes/app_router.dart';

class ApiConfigController extends GetxController {
  String? _dataBaseSelected = 'SQL-Api';
  final List<String> _dataBases = <String>['SQL-Api', 'SYBASE'];

  final apiNameController = TextEditingController();
  final portController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  List<String> get dataBases => _dataBases;

  set databaseSelected(String? value) {
    _dataBaseSelected = value;
    update();
  }

  String? get databaseSelected => _dataBaseSelected;

  @override
  void onInit() {
    super.onInit();
    fillForm();
  }

  @override
  void onClose() {
    super.onClose();
    apiNameController.dispose();
    portController.dispose();
  }

  Future<void> fillForm() async {
    final model = await AppApiFileInit.getConfg();
    if (model == null) return;
    apiNameController.text = model.hostServer;
    portController.text = model.port;
  }

  Future<bool> testApi() async {
    String host = apiNameController.text.trim();
    String port = portController.text.replaceAll('.', '');

    if (host.isEmpty || port.isEmpty) {
      customDialog(
        title: 'Erro',
        canCloseWindow: false,
        Get.context!,
        message: 'Preencha todos os campos',
      );

      return false;
    }

    try {
      return await LoadingProcessDialogGenericWidget.show<bool>(
        canCloseWindow: false,
        context: Get.context!,
        process: () {
          return Get.find<AppClientHttp>().ping(host: host, port: port);
        },
      );
    } catch (_) {
      return false;
    }
  }

  void voltar() {
    Get.offAllNamed(AppRouter.login);
  }

  Future<void> save() async {
    if (formKey.currentState!.validate()) {
      final apiServerModel = ApiServerModel(
        hostServer: apiNameController.text.trim(),
        port: portController.text.replaceAll('.', ''),
      );

      final respose = await testApi();
      if (!respose) return;

      await AppApiFileInit.setConfg(apiServerModel);
      if (Get.isRegistered<AppClientHttp>()) {
        await Get.find<AppClientHttp>().applyConfig();
      }
      if (Get.isRegistered<AppSocketConfig>()) {
        await Get.find<AppSocketConfig>().reconnectFromConfig();
      }
      Get.toNamed(AppRouter.serverConfig);
    }
  }
}
