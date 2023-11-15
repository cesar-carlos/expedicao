import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SepararGridColumns {
  final padding = const EdgeInsets.only(left: 3, right: 3);
  final List<GridColumn> _columns = [];

  SepararGridColumns() {
    _buidColumns();
  }

  List<GridColumn> get columns {
    return _columns;
  }

  void _buidColumns() {
    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codEmpresa',
        label: Container(
          padding: padding,
          alignment: Alignment.center,
          child: const Text(
            'Empresa',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codSepararEstoque',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'codSepararEstoque',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 40,
        columnName: 'item',
        label: Container(
          padding: padding,
          alignment: Alignment.center,
          child: const Text(
            'Item',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'fotoProduto',
        label: Container(
          padding: padding,
          alignment: Alignment.center,
          child: const Text(
            'Foto',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'origem',
        label: Container(
          padding: padding,
          alignment: Alignment.center,
          child: const Text('origem'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codOrigem',
        label: Container(
          padding: padding,
          alignment: Alignment.center,
          child: const Text(
            'codOrigem',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'itemOrigem',
        label: Container(
          padding: padding,
          alignment: Alignment.center,
          child: const Text(
            'itemOrigem',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codLocaArmazenagem',
        label: Container(
          padding: padding,
          alignment: Alignment.center,
          child: const Text(
            'codLocaArmazenagem',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        columnWidthMode: ColumnWidthMode.lastColumnFill,
        columnName: 'nomeLocaArmazenagem',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'nomeLocaArmazenagem',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 70,
        columnName: 'codProduto',
        label: Container(
          padding: padding,
          alignment: Alignment.center,
          child: const Text(
            'Produto',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        columnName: 'nomeProduto',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Nome Produto',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'ativo',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'ativo',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codTipoProduto',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'codTipoProduto',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 40,
        columnName: 'codUnidadeMedida',
        label: Container(
          padding: padding,
          alignment: Alignment.center,
          child: const Text(
            'UN',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        maximumWidth: 120,
        columnName: 'nomeUnidadeMedida',
        label: Container(
          padding: padding,
          alignment: Alignment.center,
          child: const Text(
            'Unidade Medida',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codGrupoProduto',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'codGrupoProduto',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        maximumWidth: 120,
        columnName: 'nomeGrupoProduto',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Grupo Produto',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        maximumWidth: 40,
        columnName: 'codMarca',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'codMarca',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 120,
        columnName: 'nomeMarca',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Nome Marca',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codSetorEstoque',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'codSetorEstoque',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 130,
        columnName: 'nomeSetorEstoque',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Setor',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        maximumWidth: 60,
        columnName: 'ncm',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'ncm',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        maximumWidth: 100,
        columnName: 'codigoBarras',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Codigo Barras',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        maximumWidth: 100,
        columnName: 'codigoBarras2',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Codigo Barras2',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 130,
        columnName: 'codigoReferencia',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Codigo Referencia',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        maximumWidth: 130,
        columnName: 'codigoFornecedor',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Codigo Fornecedor',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        maximumWidth: 130,
        columnName: 'codigoFabricante',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Codigo Fabricante',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        maximumWidth: 130,
        columnName: 'codigoOriginal',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Codigo Original',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 110,
        columnName: 'endereco',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Endereço',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 75,
        columnName: 'quantidade',
        label: Container(
          alignment: Alignment.center,
          child: const Text(
            'Qtd. Expedição',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 75,
        columnName: 'quantidadeInterna',
        label: Container(
          alignment: Alignment.center,
          child: const Text(
            'Qtd. Interna',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 75,
        columnName: 'quantidadeExterna',
        label: Container(
          alignment: Alignment.center,
          child: const Text(
            'Qtd. Externa',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 75,
        columnName: 'quantidadeSeparacao',
        label: Container(
          padding: padding,
          alignment: Alignment.center,
          child: const Text(
            'Qtd. Separada',
          ),
        ),
      ),
    );
  }
}
