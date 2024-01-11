import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:brasil_fields/brasil_fields.dart' as brasil_fields;

class ManagerController extends GetxController {
  final formKey = GlobalKey<FormState>();
  FilePickerResult? _file;

  final cnpjController = TextEditingController();
  final clientId = TextEditingController();
  final clientSecret = TextEditingController();

  String? validCNPJController(String? value) {
    if (value == null || value.isEmpty || value.length < 2) {
      return 'CNPJ is required';
    }

    if (!brasil_fields.CNPJValidator.isValid(value)) {
      if (value == '00.000.000/0000-00') {
        return null;
      }

      return 'CNPJ is invalid';
    }

    return null;
  }

  String? valisClientId(String? value) {
    if (value == null || value.isEmpty || value.length < 2) {
      return 'Client ID is required';
    }

    return null;
  }

  String? validClientSecret(String? value) {
    if (value == null || value.isEmpty || value.length < 2) {
      return 'Client Secret is required';
    }

    return null;
  }

  String? validselectFile() {
    if (_file == null) {
      return 'certificate is required';
    }

    return null;
  }

  final List<String> gerenciadora = <String>[' GERENCIA-NET '].obs;
  String gerenciadoraSelected = ' GERENCIA-NET ';

  setDatabaseSelected(String value) {
    gerenciadoraSelected = value;
    update();
  }

  selectFile() async {
    _file = await FilePicker.platform.pickFiles(
      dialogTitle: 'Selecione o cerificado',
      type: FileType.custom,
      allowedExtensions: ['p12'],
    );
  }

  void subimit() {
    if (validselectFile() != null) {
      Get.snackbar(
        'Erro',
        validselectFile()!,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        margin: const EdgeInsets.all(20),
        maxWidth: 400.0,
      );

      return;
    }

    if (formKey.currentState!.validate()) {
      print(_file);
    }
  }

  @override
  void onClose() {
    cnpjController.dispose();
    clientId.dispose();
    clientSecret.dispose();
    super.onClose();
  }
}
