import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/pages/conferido_carrinhos/grid/conferido_carrinho_grid_cells.dart';
import 'package:app_expedicao/src/pages/conferido_carrinhos/grid/conferido_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/app/app_helper.dart';

class ConferidoCarrinhoGridSource extends DataGridSource {
  var controller = Get.find<ConferidoCarrinhoGridController>();
  List<DataGridRow> _itens = [];

  ConferidoCarrinhoGridSource(
      {required List<ExpedicaoCarrinhoPercursoConsultaModel> itens}) {
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
                value: i.codUsuarioInicio,
              ),
              DataGridCell<String>(
                columnName: 'nomeUsuario',
                value: i.nomeUsuarioInicio,
              ),
              DataGridCell<Widget>(
                columnName: 'actions',
                value:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                    icon: controller.iconRemove(i),
                    onPressed: () {
                      controller.onRemoveItem(this, i);
                    },
                  ),
                  const SizedBox(
                    width: 10,
                    child: VerticalDivider(
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                  ),
                  IconButton(
                    icon: controller.iconEdit(i),
                    onPressed: () {
                      controller.onEditItem(this, i);
                    },
                  ),
                  const SizedBox(
                    width: 10,
                    child: VerticalDivider(
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                  ),
                  IconButton(
                    icon: controller.iconSave(i),
                    onPressed: () {
                      controller.onSavetem(this, i);
                    },
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
    var dataGridRowAdapter = DataGridRowAdapter(
        color: Colors.white,
        cells: row.getCells().map<Widget>((cell) {
          if (cell.value is double) {
            return ConferidoCarrinhoGridCells.defaultMoneyCell(cell.value);
          }

          if (cell.value is int) {
            return ConferidoCarrinhoGridCells.defaultIntCell(cell.value);
          }

          if (cell.value is Widget) {
            return ConferidoCarrinhoGridCells.defaultWidgetCell(cell.value);
          }

          if (cell.value is Image) {
            return ConferidoCarrinhoGridCells.defaultImageCell(cell.value);
          }

          if (cell.columnName == 'item' ||
              cell.columnName == 'codUnidadeMedida') {
            return ConferidoCarrinhoGridCells.defaultCells(
              cell.value,
              alignment: Alignment.center,
            );
          }

          return ConferidoCarrinhoGridCells.defaultCells(cell.value);
        }).toList());

    return dataGridRowAdapter;
  }
}
