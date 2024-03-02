import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/separar/separar_controller.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid.dart';
import 'package:app_expedicao/src/app/app_color.dart';

class SepararItensWidget extends StatelessWidget {
  final Size size;

  const SepararItensWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SepararController>(
      builder: (controller) {
        return SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Container(
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
                  color: AppColor.primaryColor,
                ),
                child: Center(
                  child: Text(
                    'SEPARAÇÃO ITENS - ${controller.expedicaoSituacaoDisplay.toUpperCase()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: SepararGrid(),
              )
            ],
          ),
        );
      },
    );
  }
}
