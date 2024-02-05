import 'package:flutter/material.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';

class FooterPageFormElement extends StatelessWidget {
  final ProcessoExecutavelModel processoExecutavel;
  final String? message;

  const FooterPageFormElement({
    super.key,
    required this.processoExecutavel,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: 21,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 40, 100, 130),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              fit: BoxFit.contain,
              image: AssetImage('assets/images/log_white32px.png'),
            ),
          ],
        ),
      ),
    );
  }
}
