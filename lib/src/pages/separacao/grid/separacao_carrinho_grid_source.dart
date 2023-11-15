import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:app_expedicao/src/app/app_helper.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';
import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_cells.dart';
import 'package:app_expedicao/src/pages/separacao/grid/separacao_carrinho_grid_controller.dart';

class SeparacaoCarrinhoGridSource extends DataGridSource {
  var controller = Get.find<SeparacaoCarrinhoGridController>();
  List<DataGridRow> _itens = [];

  SeparacaoCarrinhoGridSource(List<ExpedicaSeparacaoItemConsultaModel> itens) {
    _itens = itens
        .map<DataGridRow>((i) => DataGridRow(cells: [
              DataGridCell<int>(
                columnName: 'codEmpresa',
                value: i.codEmpresa,
              ),
              DataGridCell<int>(
                columnName: 'codSepararEstoque',
                value: i.codSepararEstoque,
              ),
              DataGridCell<String>(
                columnName: 'item',
                value: i.item,
              ),
              DataGridCell<String>(
                columnName: 'sessionId',
                value: i.sessionId,
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
              DataGridCell<int>(
                columnName: 'codSeparador',
                value: i.codSeparador,
              ),
              DataGridCell<String>(
                columnName: 'nomeSeparador',
                value: i.nomeSeparador,
              ),
              DataGridCell<String>(
                columnName: 'dataSeparacao',
                value: AppHelper.formatarData(i.dataSeparacao),
              ),
              DataGridCell<String>(
                columnName: 'horaSeparacao',
                value: i.horaSeparacao,
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
                      //controller.editSeparacaoItensCarrinhoGrid(this, i)
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
                      //controller.deleteSeparacaoItensCarrinhoGrid(this, i);
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
    final rowPar = _itens.indexOf(row) % 2 == 0;

    return DataGridRowAdapter(
        color: rowPar ? Colors.grey[300] : Colors.white,
        cells: row.getCells().map<Widget>((cell) {
          if (cell.value is double) {
            return SeparacaoCarrinhoGridCells.defaultMoneyCell(cell.value);
          }

          if (cell.value is int) {
            return SeparacaoCarrinhoGridCells.defaultIntCell(cell.value);
          }

          if (cell.value is Widget) {
            return SeparacaoCarrinhoGridCells.defaultWidgetCell(cell.value);
          }

          if (cell.columnName == 'item' ||
              cell.columnName == 'codUnidadeMedida') {
            return SeparacaoCarrinhoGridCells.defaultCells(
              cell.value,
              alignment: Alignment.center,
            );
          }
          return SeparacaoCarrinhoGridCells.defaultCells(cell.value);
        }).toList());
  }
}
