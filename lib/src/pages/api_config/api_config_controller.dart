import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:app_expedicao/src/app/app_Api_file_init.dart';
import 'package:app_expedicao/src/pages/common/widget/message_dialog.widget.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_process_dialog_generic_widget.dart';
import 'package:app_expedicao/src/model/api_server_model.dart';
import 'package:app_expedicao/src/routes/app_router.dart';

class ApiConfigController extends GetxController {
  String? _dataBaseSelected = 'SQL-Api';
  final List<String> _dataBases = <String>['SQL-Api', 'SYBASE'];

  final apiNameController = TextEditingController();
  final portController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  get dataBases => _dataBases;

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
    var url = Uri.http('$host:$port', '/health');

    if (host.isEmpty || port.isEmpty) {
      customDialog(
        Get.context!,
        title: 'Erro',
        message: 'Preencha todos os campos',
      );

      return false;
    }

    return await LoadingProcessDialogGenericWidget.show<bool>(
      context: Get.context!,
      process: () async {
        try {
          final response = await http.get(url);
          if (response.statusCode == 200) {
            return true;
          } else {
            return false;
          }
        } catch (err) {
          throw Exception(err);
        }
      },
    );
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
      Get.toNamed(AppRouter.serverConfig);
    }
  }
}
