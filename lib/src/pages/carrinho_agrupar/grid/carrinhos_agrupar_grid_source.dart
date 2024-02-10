import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/pages/carrinho_agrupar/grid/carrinhos_agrupar_grid_cells.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar/grid/carrinhos_agrupar_grid_controller.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_consulta_model.dart';
import 'package:app_expedicao/src/app/app_helper.dart';

class CarrinhosAgruparGridSource extends DataGridSource {
  var controller = Get.find<CarrinhosAgruparGridController>();
  List<DataGridRow> _itens = [];

  CarrinhosAgruparGridSource(
      {required List<ExpedicaoCarrinhoPercursoEstagioConsultaModel> itens}) {
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
                    onPressed: () => controller.onRemoveItem(this, i),
                  ),
                  const SizedBox(
                    width: 10,
                    child: VerticalDivider(
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                  ),
                  IconButton(
                    icon: controller.iconGroup(i),
                    onPressed: () => controller.onGroupItem(this, i),
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
            return CarrinhosAgruparGridCells.defaultMoneyCell(cell.value);
          }

          if (cell.value is int) {
            return CarrinhosAgruparGridCells.defaultIntCell(cell.value);
          }

          if (cell.value is Widget) {
            return CarrinhosAgruparGridCells.defaultWidgetCell(cell.value);
          }

          if (cell.value is Image) {
            return CarrinhosAgruparGridCells.defaultImageCell(cell.value);
          }

          if (cell.columnName == 'item' ||
              cell.columnName == 'codUnidadeMedida') {
            return CarrinhosAgruparGridCells.defaultCells(
              cell.value,
              alignment: Alignment.center,
            );
          }

          return CarrinhosAgruparGridCells.defaultCells(cell.value);
        }).toList());

    return dataGridRowAdapter;
  }
}
