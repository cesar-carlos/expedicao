import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/conferir/conferir_controller.dart';
import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid.dart';

class ConferirItensWidget extends StatelessWidget {
  final Size size;

  const ConferirItensWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConferirController>(
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
                    //'CONFERIR ITENS - ${controller.expedicaoSituacaoDisplay.toUpperCase()}',
                    'CONFERIR ITENS ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Expanded(child: ConferirGrid())
            ],
          ),
        );
      },
    );
  }
}
