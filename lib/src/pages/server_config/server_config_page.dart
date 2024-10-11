import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/server_config/server_config_controller.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';

class ServerConfigPage extends StatelessWidget {
  const ServerConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GetBuilder<ServerConfigController>(
      builder: (controller) => Scaffold(
        body: Center(
          child: Container(
            width: 700,
            height: size.height,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(75),
            constraints: const BoxConstraints(maxWidth: 1300),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: const Text(
                      'CONFIGURAÇÃO DO SERVIDOR',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FormField<String>(
                    initialValue: controller.databaseSelected,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecione uma opção';
                      }
                      return null;
                    },
                    builder: (FormFieldState<String> state) {
                      return Container(
                        height: 50,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: state.value != null
                                  ? Colors.black87
                                  : Colors.red),
                        ),
                        child: DropdownButton<String>(
                          hint: const Text('Selecione um banco de dados'),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                          value: state.value,
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(10),
                          onChanged: (String? newValue) {
                            state.didChange(newValue);
                            controller.databaseSelected = newValue;
                          },
                          items: <String>[...controller.dataBases]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    textAlign: TextAlign.start,
                    controller: controller.serverNameController,
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
                  TextFormField(
                    textAlign: TextAlign.start,
                    controller: controller.userNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Usuário é obrigatório';
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
                      labelText: 'Usuário',
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 11),
                  TextFormField(
                    textAlign: TextAlign.start,
                    controller: controller.passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Senha é obrigatório';
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 11),
                  TextFormField(
                    textAlign: TextAlign.start,
                    controller: controller.databaseNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Banco de dados é obrigatório';
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
                      labelText: 'Banco de dados',
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
                          'SALVAR',
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
