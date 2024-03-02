import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_cells.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_item_consulta_model.dart';
import 'package:app_expedicao/src/pages/conferir/grid/conferir_grid_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ConferirSource extends DataGridSource {
  var controller = Get.find<ConferirGridController>();
  List<DataGridRow> _itens = [];

  ConferirSource(List<ExpedicaoConferirItemConsultaModel> itens) {
    _itens = itens
        .map<DataGridRow>((i) => DataGridRow(
              cells: [
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
                  columnName: 'codCarrinhoPercurso',
                  value: i.codCarrinhoPercurso,
                ),
                DataGridCell<String>(
                  columnName: 'itemCarrinhoPercurso',
                  value: i.itemCarrinhoPercurso,
                ),
                DataGridCell<String>(
                  columnName: 'situacaoCarrinhoPercurso',
                  value: i.itemCarrinhoPercurso,
                ),
                DataGridCell<int>(
                  columnName: 'codProduto',
                  value: i.codProduto,
                ),
                DataGridCell<String>(
                  columnName: 'nomeProduto',
                  value: i.nomeProduto,
                ),
                DataGridCell<String>(
                  columnName: 'codUnidadeMedida',
                  value: i.codUnidadeMedida,
                ),
                DataGridCell<String>(
                  columnName: 'nomeUnidadeMedida',
                  value: i.nomeUnidadeMedida,
                ),
                DataGridCell<int>(
                  columnName: 'codGrupoProduto',
                  value: i.codGrupoProduto,
                ),
                DataGridCell<String>(
                  columnName: 'nomeGrupoProduto',
                  value: i.nomeGrupoProduto,
                ),
                DataGridCell<int>(
                  columnName: 'codMarca',
                  value: i.codMarca,
                ),
                DataGridCell<String>(
                  columnName: 'nomeMarca',
                  value: i.nomeMarca,
                ),
                DataGridCell<int>(
                  columnName: 'codSetorEstoque',
                  value: i.codSetorEstoque,
                ),
                DataGridCell<String>(
                  columnName: 'nomeSetorEstoque',
                  value: i.nomeSetorEstoque,
                ),
                DataGridCell<String>(
                  columnName: 'codigoBarras',
                  value: i.codigoBarras,
                ),
                DataGridCell<String>(
                  columnName: 'codigoBarras2',
                  value: i.codigoBarras2,
                ),
                DataGridCell<String>(
                  columnName: 'codigoReferencia',
                  value: i.codigoReferencia,
                ),
                DataGridCell<String>(
                  columnName: 'codigoFornecedor',
                  value: i.codigoFornecedor,
                ),
                DataGridCell<String>(
                  columnName: 'codigoFabricante',
                  value: i.codigoFabricante,
                ),
                DataGridCell<String>(
                  columnName: 'codigoOriginal',
                  value: i.codigoOriginal,
                ),
                DataGridCell<String>(
                  columnName: 'endereco',
                  value: i.endereco,
                ),
                DataGridCell<String>(
                  columnName: 'enderecoDescricao',
                  value: i.enderecoDescricao,
                ),
                DataGridCell<double>(
                  columnName: 'quantidade',
                  value: i.quantidade,
                ),
                DataGridCell<double>(
                  columnName: 'quantidadeConferida',
                  value: i.quantidadeConferida,
                ),
              ],
            ))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _itens;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final columnValueItem = row.getCells()[3].value;
    final item = controller.findItem(columnValueItem);

    var dataGridRowAdapter = DataGridRowAdapter(
        color: controller.rowColor(row, item),
        cells: row.getCells().map<Widget>((cell) {
          if (cell.value is double) {
            return ConferirGridCell.defaultMoneyCell(cell.value);
          }

          if (cell.value is int) {
            return ConferirGridCell.defaultIntCell(cell.value);
          }

          if (cell.value is Widget) {
            return ConferirGridCell.defaultWidgetCell(cell.value);
          }

          if (cell.value is Image) {
            return ConferirGridCell.defaultImageCell(cell.value);
          }

          if (cell.columnName == 'item' ||
              cell.columnName == 'codUnidadeMedida') {
            return ConferirGridCell.defaultCells(
              cell.value,
              alignment: Alignment.center,
            );
          }

          return ConferirGridCell.defaultCells(cell.value);
        }).toList());

    return dataGridRowAdapter;
  }
}
