import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';

import 'package:app_expedicao/src/pages/manager_config/manager_controller.dart';

class ManagerPage extends StatelessWidget {
  const ManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GetBuilder<ManagerController>(
      builder: (_) => Scaffold(
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Form(
            child: SingleChildScrollView(
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Align(
                  alignment: Alignment.center,
                  child: Form(
                    key: _.formKey,
                    child: SizedBox(
                      width: size.width * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'GERENCIADOR PIX',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Obx(
                            () => DropdownButton<String>(
                              value: _.gerenciadoraSelected,
                              isExpanded: true,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              hint: const Text('Selecione a gerenciadora'),
                              icon: const Icon(Icons.arrow_drop_down),
                              items: _.gerenciadora.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                _.setDatabaseSelected(value!);
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _.cnpjController,
                            validator: _.validCNPJController,
                            decoration: const InputDecoration(
                              labelText: 'CNPJ',
                              border: OutlineInputBorder(),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CnpjInputFormatter(),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _.clientId,
                            validator: _.valisClientId,
                            decoration: const InputDecoration(
                              labelText: 'client id',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _.clientSecret,
                            validator: _.validClientSecret,
                            decoration: const InputDecoration(
                              labelText: 'client secret',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton.icon(
                                  icon: const Icon(
                                    color: Colors.white,
                                    Icons.file_copy_outlined,
                                  ),
                                  label: const Text(
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    'CERTIFICADO',
                                  ),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 15)),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      const Color.fromARGB(255, 70, 194, 74),
                                    ),
                                  ),
                                  onPressed: _.selectFile),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: size.width * 0.5,
                            height: size.height * 0.05,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    'VOLTAR',
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: _.subimit,
                                  child: const Text(
                                    'SALVAR',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
