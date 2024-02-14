import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/model/expedicao_carrinho_conferir_consulta_model.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/grid/conferir_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/conferir_carrinhos/grid/conferir_carrinho_grid_cells.dart';
import 'package:app_expedicao/src/app/app_helper.dart';

class ConferirCarrinhoGridSource extends DataGridSource {
  var controller = Get.find<ConferirCarrinhoGridController>();
  List<DataGridRow> _itens = [];

  ConferirCarrinhoGridSource(
      {required List<ExpedicaoCarrinhoConferirConsultaModel> itens}) {
    _itens = itens
        .map<DataGridRow>((i) => DataGridRow(cells: [
              DataGridCell<Widget>(
                columnName: 'indicator',
                value: controller.iconIndicator(i),
              ),
              DataGridCell<int>(
                columnName: 'codEmpresa',
                value: i.codEmpresa,
              ),
              DataGridCell<int>(
                columnName: 'codConferir',
                value: i.codConferir,
              ),
              DataGridCell<String>(
                columnName: 'origem',
                value: i.origem,
              ),
              DataGridCell<int>(
                columnName: 'codOrigem',
                value: i.codOrigem,
              ),
              DataGridCell<int>(
                columnName: 'codCarrinhoPercurso',
                value: i.codCarrinhoPercurso,
              ),
              DataGridCell<String>(
                columnName: 'itemCarrinhoPercurso',
                value: i.itemCarrinhoPercurso,
              ),
              DataGridCell<int>(
                columnName: 'codPrioridade',
                value: i.codPrioridade,
              ),
              DataGridCell<String>(
                columnName: 'nomePrioridade',
                value: i.nomePrioridade,
              ),
              DataGridCell<int>(
                columnName: 'codCarrinho',
                value: i.codCarrinho,
              ),
              DataGridCell<String>(
                columnName: 'nomeCarrinho',
                value: i.nomeCarrinho,
              ),
              DataGridCell<String>(
                columnName: 'codigoBarrasCarrinho',
                value: i.codigoBarrasCarrinho,
              ),
              DataGridCell<String>(
                columnName: 'situacaoCarrinho',
                value: i.situacaoCarrinhoConferencia,
              ),
              DataGridCell<String>(
                columnName: 'dataInicioPercurso',
                value: AppHelper.formatarData(i.dataInicioPercurso),
              ),
              DataGridCell<String>(
                columnName: 'horaInicioPercurso',
                value: i.horaInicioPercurso,
              ),
              DataGridCell<int>(
                columnName: 'codPercursoEstagio',
                value: i.codPercursoEstagio,
              ),
              DataGridCell<String>(
                columnName: 'nomePercursoEstagio',
                value: i.nomePercursoEstagio,
              ),
              DataGridCell<int>(
                columnName: 'codUsuarioInicioEstagio',
                value: i.codUsuarioInicioEstagio,
              ),
              DataGridCell<String>(
                columnName: 'nomeUsuarioInicioEstagio',
                value: i.nomeUsuarioInicioEstagio,
              ),
              DataGridCell<String>(
                columnName: 'dataInicioEstagio',
                value: AppHelper.formatarData(i.dataInicioEstagio),
              ),
              DataGridCell<String>(
                columnName: 'horaInicioEstagio',
                value: i.horaInicioEstagio,
              ),
              DataGridCell<int>(
                columnName: 'codUsuarioFinalizacaoEstagio',
                value: i.codUsuarioFinalizacaoEstagio,
              ),
              DataGridCell<String>(
                columnName: 'nomeUsuarioFinalizacaoEstagio',
                value: i.nomeUsuarioFinalizacaoEstagio,
              ),
              DataGridCell<String>(
                columnName: 'dataFinalizacaoEstagio',
                value: AppHelper.formatarData(i.dataFinalizacaoEstagio),
              ),
              DataGridCell<String>(
                columnName: 'horaFinalizacaoEstagio',
                value: i.horaFinalizacaoEstagio,
              ),
              // DataGridCell<Widget>(
              //   columnName: 'actions',
              //   value:
              //       Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              //     IconButton(
              //       icon: controller.iconRemove(i),
              //       onPressed: () {
              //         controller.onRemoveItem(this, i);
              //       },
              //     ),
              //     const SizedBox(
              //       width: 10,
              //       child: VerticalDivider(
              //         color: Colors.grey,
              //         thickness: 0.5,
              //       ),
              //     ),
              //     IconButton(
              //       icon: controller.iconEdit(i),
              //       onPressed: () {
              //         controller.editGrid(this, i);
              //       },
              //     ),
              //     const SizedBox(
              //       width: 10,
              //       child: VerticalDivider(
              //         color: Colors.grey,
              //         thickness: 0.5,
              //       ),
              //     ),
              //     IconButton(
              //       icon: controller.iconSave(i),
              //       onPressed: () {
              //         controller.onSavetem(this, i);
              //       },
              //     ),
              //   ]),
              // ),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _itens;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        color: Colors.white,
        cells: row.getCells().map<Widget>((cell) {
          if (cell.value is double) {
            return ConferirCarrinhoGridCells.defaultMoneyCell(cell.value);
          }

          if (cell.value is int) {
            return ConferirCarrinhoGridCells.defaultIntCell(cell.value);
          }

          if (cell.value is Widget) {
            return ConferirCarrinhoGridCells.defaultWidgetCell(cell.value);
          }

          return ConferirCarrinhoGridCells.defaultCells(cell.value);
        }).toList());
  }
}
