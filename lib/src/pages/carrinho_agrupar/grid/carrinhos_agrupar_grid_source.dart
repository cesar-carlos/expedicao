import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/pages/carrinho_agrupar/grid/carrinhos_agrupar_grid_cells.dart';
import 'package:app_expedicao/src/pages/carrinho_agrupar/grid/carrinhos_agrupar_grid_controller.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_agrupamento_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/widget/shortcut_badge.dart';
import 'package:app_expedicao/src/app/app_helper.dart';

class CarrinhosAgruparGridSource extends DataGridSource {
  var controller = Get.find<CarrinhosAgruparGridController>();
  List<DataGridRow> _itens = [];

  CarrinhosAgruparGridSource(
      {required List<ExpedicaoCarrinhoPercursoAgrupamentoConsultaModel>
          itens}) {
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
                value: i.itemCarrinhoPercurso,
              ),
              DataGridCell<String>(
                columnName: 'origem',
                value: i.origem,
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
                  ShortcutBadge(
                    shortCut: 'Del',
                    tooltip: 'Desagrupar Carrinho (Del)',
                    onPressed: () {
                      controller.onRemoveItem(this, i);
                    },
                    child: controller.iconRemove(i),
                  ),
                  const SizedBox(
                    width: 9,
                    child: VerticalDivider(
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                  ),
                  ShortcutBadge(
                    shortCut: 'F6',
                    tooltip: 'Agrupar Carrinho (F6)',
                    onPressed: () {
                      controller.onGroupItem(this, i);
                    },
                    child: controller.iconGroup(i),
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
    final itemCell = row.getCells().where((cell) => cell.columnName == 'item');
    final itemValue = itemCell.isEmpty ? null : itemCell.first.value?.toString();
    final item = itemValue == null
        ? null
        : controller.itens
            .where((el) => el.itemCarrinhoPercurso == itemValue)
            .firstOrNull;

    return DataGridRowAdapter(
        color: item == null ? Colors.white : controller.rowColor(item),
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
  }
}
