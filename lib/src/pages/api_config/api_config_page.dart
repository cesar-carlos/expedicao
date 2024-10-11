import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/api_config/api_config_controller.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';

class ApiConfigPage extends StatelessWidget {
  const ApiConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GetBuilder<ApiConfigController>(
      builder: (controller) => Scaffold(
        body: Center(
          child: Container(
            width: 700,
            height: size.height * 0.5,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(50),
            constraints: const BoxConstraints(maxWidth: 1300),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: const Text(
                      'CONFIGURAÇÃO API',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextFormField(
                    textAlign: TextAlign.start,
                    controller: controller.apiNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Servidor é obrigatório';
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      labelText: 'Servidor',
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    textAlign: TextAlign.start,
                    controller: controller.portController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Porta é obrigatório';
                      }

                      return null;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      NumberTextInputFormatter(
                        integerDigits: 10,
                        decimalDigits: 0,
                        decimalSeparator: ',',
                        groupDigits: 3,
                        groupSeparator: '.',
                        allowNegative: false,
                        overrideDecimalPoint: true,
                        insertDecimalPoint: false,
                        insertDecimalDigits: true,
                      ),
                    ],
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      labelText: 'Porta',
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 11),
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 10,
                              bottom: 10,
                            ),
                          ),
                          backgroundColor:
                              WidgetStateProperty.all(Colors.black),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        onPressed: controller.voltar,
                        child: const Text(
                          'VOLTAR',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 10,
                              bottom: 10,
                            ),
                          ),
                          backgroundColor:
                              WidgetStateProperty.all(Colors.black),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        onPressed: controller.save,
                        child: const Text(
                          'PRÓXIMO',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
