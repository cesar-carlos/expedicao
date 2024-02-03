import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SeparadoCarrinhoGridColumns {
  final padding = const EdgeInsets.only(left: 3, right: 3);
  final List<GridColumn> _columns = [];

  SeparadoCarrinhoGridColumns() {
    _buidColumns();
  }

  List<GridColumn> get columns {
    return _columns;
  }

  void _buidColumns() {
    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 30,
        columnName: 'indicator',
        label: Container(
          padding: padding,
          alignment: Alignment.center,
          child: const Text(
            '',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codEmpresa',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'codEmpresa',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codCarrinhoPercurso',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'codCarrinhoPercurso',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'item',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'item',
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
          alignment: Alignment.centerLeft,
          child: const Text(
            'origem',
          ),
        ),
      ),
    );
    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codOrigem',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'codOrigem',
          ),
        ),
      ),
    );
    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 80,
        columnName: 'codCarrinho',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Carrinho',
          ),
        ),
      ),
    );
    _columns.add(
      GridColumn(
        visible: true,
        columnName: 'nomeCarrinho',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Nome Carrinho',
          ),
        ),
      ),
    );
    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 200,
        columnName: 'codigoBarrasCarrinho',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Código Barras',
          ),
        ),
      ),
    );
    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 150,
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
        visible: true,
        columnName: 'dataInicio',
        maximumWidth: 110,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Data Inicio',
          ),
        ),
      ),
    );
    _columns.add(
      GridColumn(
        visible: true,
        columnName: 'horaInicio',
        maximumWidth: 110,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Hora Inicio',
          ),
        ),
      ),
    );
    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codUsuario',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'codUsuario',
          ),
        ),
      ),
    );
    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 160,
        columnName: 'nomeUsuario',
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Usuario',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        maximumWidth: 140,
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
