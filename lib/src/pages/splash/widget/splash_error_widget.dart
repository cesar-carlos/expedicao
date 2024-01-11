import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/routes/app_router.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class SplashErrorWidget extends StatefulWidget {
  final String erroCode;
  final String? message;

  const SplashErrorWidget({
    super.key,
    required this.erroCode,
    this.message = '',
  });

  @override
  State<SplashErrorWidget> createState() => _ComplitAnimationIconWidgetState();
}

class _ComplitAnimationIconWidgetState extends State<SplashErrorWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      color: Colors.blueGrey[50],
      child: Column(
        children: [
          const SizedBox(height: 100),
          SizedBox(
            width: size.width,
            height: size.height * .5,
            child: Lottie.asset(
              alignment: Alignment.center,
              'assets/icons/server_desconected_animation.json',
              controller: _controller,
              onLoaded: (composition) {
                _controller
                  ..duration = composition.duration
                  ..forward()
                  ..repeat();
              },
            ),
          ),
          SizedBox(
            width: size.width * .8,
            child: Text(
              getErrorDescription(widget.erroCode),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Get.offAllNamed(AppRouter.login),
            icon: const Icon(
              BootstrapIcons.gear_fill,
            ),
          ),
        ],
      ),
    );
  }

  getErrorDescription(String code) {
    final error =
        _errorMessage.firstWhere((element) => element['code'] == code);

    return error['message'];
  }

  final List<Map<String, dynamic>> _errorMessage = [
    {
      'code': '0001',
      'title': 'Servidor não encontrado',
      'message': '''
        Não foi possível localizar o servidor.
        
        1) Verifique se o servidor está online.
        2) Verifique se o banco de dados está online.
        3) Verifique se o banco de dados está configurado corretamente.
      ''',
    },
    {
      'code': '0002',
      'title': 'Não foi possível executar o processo',
      'message': '''
        Não foi possível executar o processo.
        
        1) Verifique se o servidor está online.
        2) Verifique se o banco de dados está online.
        3) Verifique se o banco de dados está configurado corretamente.
      ''',
    },
    {
      'code': '0003',
      'title': 'Não foi possível localizar itens da separação',
      'message': '''
        Não foi possível localizar itens da separação.
        
        1) Verifique se o servidor está online.
        2) Verifique se o banco de dados está online.
        3) Verifique se o banco de dados está configurado corretamente.
      ''',
    },
  ];
}
