import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/app/app_helper.dart';
import 'package:app_expedicao/src/model/expedicao_item_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_consulta_model.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_cells.dart';
import 'package:app_expedicao/src/pages/conferencia/grid/conferencia_carrinho_grid_controller.dart';

class ConferenciaCarrinhoGridSource extends DataGridSource {
  var controller = Get.find<ConferenciaCarrinhoGridController>();
  List<DataGridRow> _itens = [];

  ConferenciaCarrinhoGridSource(
      List<ExpedicaConferenciaItemConsultaModel> itens) {
    _itens = itens
        .map<DataGridRow>((i) => DataGridRow(cells: [
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
                columnName: 'sessionId',
                value: i.sessionId,
              ),
              DataGridCell<String>(
                columnName: 'situacao',
                value: ExpedicaoItemSituacaoModel.getDescricao(i.situacao),
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
              // DataGridCell<int>(
              //   columnName: 'codSetorEstoque',
              //   value: i.codSetorEstoque,
              // ),
              // DataGridCell<String>(
              //   columnName: 'nomeSetorEstoque',
              //   value: i.nomeSetorEstoque,
              // ),
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
              DataGridCell<int>(
                columnName: 'codSeparador',
                value: i.codConferente,
              ),
              DataGridCell<String>(
                columnName: 'nomeConferente',
                value: i.nomeConferente,
              ),
              DataGridCell<String>(
                columnName: 'dataConferencia',
                value: AppHelper.formatarData(i.dataConferencia),
              ),
              DataGridCell<String>(
                columnName: 'horaConferencia',
                value: i.horaConferencia,
              ),
              DataGridCell<double>(
                columnName: 'quantidade',
                value: i.quantidade,
              ),
              DataGridCell<Widget>(
                columnName: 'actions',
                value:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                    onPressed: () {
                      controller.onEditItem(this, i);
                    },
                    icon: const Icon(
                      size: 17,
                      Icons.edit,
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
                      controller.onRemoveItem(this, i);
                    },
                    icon: const Icon(
                      size: 17,
                      Icons.delete,
                      color: Colors.red,
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
    final selectedRow = controller.selectedoRows;
    if (selectedRow.contains(row)) {}

    return DataGridRowAdapter(
        color: Colors.white,
        cells: row.getCells().map<Widget>((cell) {
          if (cell.value is double) {
            return ConferenciaCarrinhoGridCells.defaultMoneyCell(cell.value);
          }

          if (cell.value is int) {
            return ConferenciaCarrinhoGridCells.defaultIntCell(cell.value);
          }

          if (cell.value is Widget) {
            return ConferenciaCarrinhoGridCells.defaultWidgetCell(cell.value);
          }

          if (cell.columnName == 'item' ||
              cell.columnName == 'codUnidadeMedida') {
            return ConferenciaCarrinhoGridCells.defaultCells(
              cell.value,
              alignment: Alignment.center,
            );
          }
          return ConferenciaCarrinhoGridCells.defaultCells(cell.value);
        }).toList());
  }
}
