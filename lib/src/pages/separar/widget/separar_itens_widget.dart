import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/separar/separar_controller.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid.dart';

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
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(0)),
                  color: Theme.of(context).primaryColor,
                ),
                width: size.width,
                child: const Center(
                  child: Text(
                    'SEPARAR ITENS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(child: SepararGrid())
            ],
          ),
        );
      },
    );
  }
}
