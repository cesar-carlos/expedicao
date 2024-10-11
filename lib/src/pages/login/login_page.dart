import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/login/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GetBuilder<LoginController>(
      builder: (_) => Scaffold(
        body: ListView(
          children: [
            Center(
              child: SizedBox(
                width: 380.0,
                height: size.height * 0.78,
                child: Form(
                  key: _.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage('assets/images/log_se7e_black.png'),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        controller: _.userController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white38,
                          border: OutlineInputBorder(),
                          labelText: 'Usuário',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _.passwordController,
                        validator: _.validPassword,
                        obscureText: true,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white38,
                          border: OutlineInputBorder(),
                          labelText: 'Senha',
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: size.width * 0.5,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all<Color>(Colors.black),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          onPressed: _.login,
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
