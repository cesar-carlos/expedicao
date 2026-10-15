import 'package:flutter/material.dart';

import 'package:app_expedicao/src/app/app_color.dart';

class CarregandoWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const CarregandoWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.backgroundColor,
      child: InkWell(
        onTap: onTap,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Carregando...',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
