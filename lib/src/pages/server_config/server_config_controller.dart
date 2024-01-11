import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/model/database_server_model.dart';
import 'package:app_expedicao/src/app/app_server_file_init.dart';
import 'package:app_expedicao/src/routes/app_router.dart';

class ServerConfigController extends GetxController {
  String? _dataBaseSelected = 'SQL-SERVER';
  final List<String> _dataBases = <String>['SQL-SERVER', 'SYBASE'];

  final serverNameController = TextEditingController();
  final portController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final databaseNameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  get dataBases => _dataBases;
  String? get databaseSelected => _dataBaseSelected;

  set databaseSelected(String? value) {
    _dataBaseSelected = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fillForm();
  }

  @override
  void onClose() {
    super.onClose();
    serverNameController.dispose();
    portController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    databaseNameController.dispose();
  }

  Future<void> fillForm() async {
    final model = await AppServerFileInit.getConfg();
    if (model == null) return;
    serverNameController.text = model.serverName;
    portController.text = model.port;
    userNameController.text = model.userName;
    passwordController.text = model.password;
    databaseNameController.text = model.databaseName;
    databaseSelected = model.database;
  }

  void voltar() {
    Get.back();
  }

  Future<void> save() async {
    if (formKey.currentState!.validate()) {
      final dataBaseServerModel = DataBaseServerModel(
        userName: userNameController.text,
        password: passwordController.text,
        serverName: serverNameController.text.trim(),
        database: databaseSelected!.trim(),
        databaseName: databaseNameController.text.trim(),
        port: portController.text,
      );

      await AppServerFileInit.setConfg(dataBaseServerModel);
      Get.toNamed(AppRouter.splash);
    }
  }
}
