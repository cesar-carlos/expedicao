import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/pages/separarado_carrinhos/grid/separarado_carrinho_grid_cells.dart';
import 'package:app_expedicao/src/pages/separarado_carrinhos/grid/separarado_carrinho_grid_controller.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_estagio_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/widget/shortcut_badge.dart';
import 'package:app_expedicao/src/app/app_helper.dart';

class SeparadoCarrinhoGridSource extends DataGridSource {
  var controller = Get.find<SeparadoCarrinhoGridController>();
  List<DataGridRow> _itens = [];

  SeparadoCarrinhoGridSource(
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
                  ShortcutBadge(
                    shortCut: 'Del',
                    tooltip: 'Excluir Carrinho (Del)',
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
                    shortCut: 'F9',
                    tooltip: 'Editar Carrinho (F9)',
                    onPressed: () {
                      controller.onEditItem(this, i);
                    },
                    child: controller.iconEdit(i),
                  ),
                  const SizedBox(
                    width: 9,
                    child: VerticalDivider(
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                  ),
                  ShortcutBadge(
                    shortCut: 'F10',
                    tooltip: 'Salvar Carrinho (F10)',
                    onPressed: () {
                      controller.onSavetem(this, i);
                    },
                    child: controller.iconSave(i),
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
        : controller.itensSort.where((el) => el.item == itemValue).firstOrNull;

    return DataGridRowAdapter(
        color: item == null ? Colors.white : controller.rowColor(item),
        cells: row.getCells().map<Widget>((cell) {
          if (cell.value is double) {
            return SeparadoCarrinhoGridCells.defaultMoneyCell(cell.value);
          }

          if (cell.value is int) {
            return SeparadoCarrinhoGridCells.defaultIntCell(cell.value);
          }

          if (cell.value is Widget) {
            return SeparadoCarrinhoGridCells.defaultWidgetCell(cell.value);
          }

          return SeparadoCarrinhoGridCells.defaultCells(cell.value);
        }).toList());
  }
}
