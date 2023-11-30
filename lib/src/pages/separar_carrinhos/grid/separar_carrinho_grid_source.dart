import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/grid/separar_carrinho_grid_cells.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/app/app_helper.dart';

class SepararCarrinhoGridSource extends DataGridSource {
  var controller = Get.find<SepararCarrinhoGridController>();
  List<DataGridRow> _itens = [];

  SepararCarrinhoGridSource(
      {required List<ExpedicaoCarrinhoPercursoConsultaModel> itens}) {
    _itens = itens
        .map<DataGridRow>((i) => DataGridRow(cells: [
              DataGridCell<int>(
                columnName: 'codEmpresa',
                value: i.codEmpresa,
              ),
              DataGridCell<int>(
                columnName: 'codCarrinhoPercurso',
                value: i.codCarrinhoPercurso,
              ),
              DataGridCell<String>(
                columnName: 'item',
                value: i.item,
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
                columnName: 'situacao',
                value: i.situacao,
              ),
              DataGridCell<String>(
                columnName: 'dataInicio',
                value: AppHelper.formatarData(i.dataInicio),
              ),
              DataGridCell<String>(
                columnName: 'horaInicio',
                value: i.horaInicio,
              ),
              DataGridCell<int>(
                columnName: 'codUsuario',
                value: i.codUsuario,
              ),
              DataGridCell<String>(
                columnName: 'nomeUsuario',
                value: i.nomeUsuario,
              ),
              DataGridCell<Widget>(
                columnName: 'actions',
                value:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                    onPressed: () {
                      controller.onRemoveItem(this, i);
                    },
                    icon: Icon(
                      size: 17,
                      Icons.delete,
                      color: i.situacao != ExpedicaoSituacaoModel.cancelada
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                    child: VerticalDivider(
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.editItemGrid(this, i);
                    },
                    icon: Icon(
                      size: 17,
                      i.situacao != ExpedicaoSituacaoModel.cancelada
                          ? Icons.edit
                          : Icons.visibility,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                    child: VerticalDivider(
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.saveItemGrid(this, i);
                    },
                    icon: const Icon(
                      size: 17,
                      Icons.save_sharp,
                      color: Colors.blue,
                    ),
                  ),
                ]),
              ),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _itens;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final selectedRow =
        controller.dataGridController.selectedRows.contains(row);

    return DataGridRowAdapter(
        color: Colors.white60,
        cells: row.getCells().map<Widget>((cell) {
          if (cell.value is double) {
            return SepararCarrinhoGridCells.defaultMoneyCell(cell.value);
          }

          if (cell.value is int) {
            return SepararCarrinhoGridCells.defaultIntCell(cell.value);
          }

          if (cell.value is Widget) {
            return SepararCarrinhoGridCells.defaultWidgetCell(cell.value);
          }

          return SepararCarrinhoGridCells.defaultCells(cell.value);
        }).toList());
  }
}
