import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_cells.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';
import 'package:app_expedicao/src/pages/separacao/grid_separar_setor/separar_setor_grid_controller.dart';

class SepararSetorSource extends DataGridSource {
  var controller = Get.find<SepararSetorGridController>();
  List<DataGridRow> _itens = [];

  SepararSetorSource(List<ExpedicaoSepararItemConsultaModel> itens) {
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
                  columnName: 'codSepararEstoque',
                  value: i.codSepararEstoque,
                ),
                DataGridCell<String>(
                  columnName: 'item',
                  value: i.item,
                ),
                const DataGridCell<Image>(
                  columnName: 'fotoProduto',
                  value: Image(
                    image: AssetImage('assets/images/produto-sem-foto.jpg'),
                  ),
                ),
                DataGridCell<String>(
                  columnName: 'origem',
                  value: i.origem,
                ),
                DataGridCell<int>(
                  columnName: 'codOrigem',
                  value: i.codOrigem,
                ),
                DataGridCell<String>(
                  columnName: 'itemOrigem',
                  value: i.itemOrigem,
                ),
                DataGridCell<int>(
                  columnName: 'codLocaArmazenagem',
                  value: i.codLocaArmazenagem,
                ),
                DataGridCell<String>(
                  columnName: 'nomeLocaArmazenagem',
                  value: i.nomeLocaArmazenagem,
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
                  columnName: 'ativo',
                  value: i.ativo,
                ),
                DataGridCell<String>(
                  columnName: 'codTipoProduto',
                  value: i.codTipoProduto,
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
                  columnName: 'ncm',
                  value: i.ncm,
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
                DataGridCell<double>(
                  columnName: 'quantidade',
                  value: i.quantidade,
                ),
                DataGridCell<double>(
                  columnName: 'quantidadeInterna',
                  value: i.quantidadeInterna,
                ),
                DataGridCell<double>(
                  columnName: 'quantidadeExterna',
                  value: i.quantidadeExterna,
                ),
                DataGridCell<double>(
                  columnName: 'quantidadeSeparacao',
                  value: i.quantidadeSeparacao,
                ),
              ],
            ))
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
            return SepararGridCell.defaultMoneyCell(cell.value);
          }

          if (cell.value is int) {
            return SepararGridCell.defaultIntCell(cell.value);
          }

          if (cell.value is Widget) {
            return SepararGridCell.defaultWidgetCell(cell.value);
          }

          if (cell.value is Image) {
            return SepararGridCell.defaultImageCell(cell.value);
          }

          if (cell.columnName == 'item' ||
              cell.columnName == 'codUnidadeMedida') {
            return SepararGridCell.defaultCells(
              cell.value,
              alignment: Alignment.center,
            );
          }

          return SepararGridCell.defaultCells(cell.value);
        }).toList());

    return dataGridRowAdapter;
  }
}
