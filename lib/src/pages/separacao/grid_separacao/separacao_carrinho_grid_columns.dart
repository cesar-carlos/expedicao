import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SeparacaoCarrinhoGridColumns {
  final padding = const EdgeInsets.only(left: 3);
  final List<GridColumn> _columns = [];

  SeparacaoCarrinhoGridColumns() {
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
          alignment: Alignment.centerLeft,
          child: const Text('codEmpresa'),
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
          child: const Text('codSepararEstoque'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 50,
        columnName: 'item',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('item'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'sessionId',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('sessionId'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        maximumWidth: 80,
        columnName: 'situacao',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Situação',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        maximumWidth: 40,
        columnName: 'codCarrinho',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Carrinho'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        maximumWidth: 110,
        columnName: 'nomeCarrinho',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Nome Carrinho'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        maximumWidth: 70,
        columnName: 'codigoBarrasCarrinho',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Código Carrinho'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 80,
        columnName: 'codProduto',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Produto'),
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
          child: const Text('Nome Produto'),
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
          child: const Text('UN'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        maximumWidth: 40,
        columnName: 'nomeUnidadeMedida',
        label: Container(
          padding: padding,
          alignment: Alignment.center,
          child: const Text('Unidade Medida'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        maximumWidth: 40,
        columnName: 'codGrupoProduto',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('codGrupoProduto'),
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
          child: const Text('Grupo Produto'),
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
          child: const Text('codMarca'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 130,
        columnName: 'nomeMarca',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Marca'),
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
          child: const Text('codSetorEstoque'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'nomeSetorEstoque',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Setor'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 100,
        columnName: 'codigoBarras',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Código Barras'),
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
          child: const Text('codigoBarras2'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codigoReferencia',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Código Referencia'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codigoFornecedor',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Código Fornecedor',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codigoFabricante',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Código Fabricante'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codigoOriginal',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Código Original'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        maximumWidth: 110,
        columnName: 'endereco',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Endereço'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 110,
        columnName: 'enderecoDescricao',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Endereço'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codSeparador',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('codSeparador'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 120,
        columnName: 'nomeSeparador',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Separador'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 80,
        columnName: 'dataSeparacao',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Dt. Separação'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 75,
        columnName: 'horaSeparacao',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Hr. Separação'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 75,
        columnName: 'quantidade',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Qtd. Separação'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 100,
        columnName: 'actions',
        label: Container(
          padding: padding,
          alignment: Alignment.center,
          child: const Text(
            'Ações',
          ),
        ),
      ),
    );
  }
}
