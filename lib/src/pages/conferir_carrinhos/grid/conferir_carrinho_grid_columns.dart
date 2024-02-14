import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ConferirCarrinhoGridColumns {
  final padding = const EdgeInsets.only(left: 3, right: 3);
  final List<GridColumn> _columns = [];

  ConferirCarrinhoGridColumns() {
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
        maximumWidth: 60,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Empr..',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        columnName: 'codConferir',
        maximumWidth: 70,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Conferir'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'origem',
        maximumWidth: 60,
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
        maximumWidth: 90,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'codOrigem',
          ),
        ),
      ),
    );

    // _columns.add(
    //   GridColumn(
    //     visible: false,
    //     columnName: 'situacao',
    //     maximumWidth: 120,
    //     label: Container(
    //       padding: padding,
    //       alignment: Alignment.centerLeft,
    //       child: const Text(
    //         'Situação',
    //       ),
    //     ),
    //   ),
    // );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codCarrinhoPercurso',
        maximumWidth: 90,
        label: Container(
          padding: padding,
          alignment: Alignment.center,
          child: const Text(
            'Carrinho Percurso',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'itemCarrinhoPercurso',
        maximumWidth: 60,
        label: Container(
          padding: padding,
          alignment: Alignment.center,
          child: const Text(
            'ItemCarrinhoPercurso',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        columnName: 'codPrioridade',
        maximumWidth: 50,
        label: Container(
          padding: padding,
          alignment: Alignment.center,
          child: const Text(
            'Prio...',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        columnName: 'nomePrioridade',
        maximumWidth: 170,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Nome Prioridade',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codCarrinho',
        maximumWidth: 70,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Carrinho'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        columnName: 'nomeCarrinho',
        //maximumWidth: 180,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Nome Carrinho'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        columnName: 'codigoBarrasCarrinho',
        maximumWidth: 130,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Código Barras'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        columnName: 'situacaoCarrinho',
        maximumWidth: 145,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Situação Carrinho',
          ),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        columnName: 'dataInicioPercurso',
        maximumWidth: 100,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Dt. Inicio Percurso'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        columnName: 'horaInicioPercurso',
        maximumWidth: 90,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Hr. Inicio Percurso'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codPercursoEstagio',
        maximumWidth: 80,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('codPercursoEstagio'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'nomePercursoEstagio',
        maximumWidth: 200,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('nomePercursoEstagio'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codUsuarioInicioEstagio',
        maximumWidth: 80,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('codUsuarioInicioEstagio'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'nomeUsuarioInicioEstagio',
        maximumWidth: 130,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('nomeUsuarioInicioEstagio'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'dataInicioEstagio',
        maximumWidth: 80,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Dt. Inicio Estagio'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'horaInicioEstagio',
        maximumWidth: 70,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Hr. Inicio Estagio'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'codUsuarioFinalizacaoEstagio',
        maximumWidth: 80,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('codUsuarioFinalizacaoEstagio'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: true,
        columnName: 'nomeUsuarioFinalizacaoEstagio',
        maximumWidth: 130,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Usuario Finalização Estagio'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'dataFinalizacaoEstagio',
        maximumWidth: 80,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Dt. Finalização Estagio'),
        ),
      ),
    );

    _columns.add(
      GridColumn(
        visible: false,
        columnName: 'horaFinalizacaoEstagio',
        maximumWidth: 70,
        label: Container(
          padding: padding,
          alignment: Alignment.centerLeft,
          child: const Text('Hr. Finalização Estagio'),
        ),
      ),
    );

    // _columns.add(
    //   GridColumn(
    //     visible: true,
    //     minimumWidth: 140,
    //     columnName: 'actions',
    //     maximumWidth: 140,
    //     label: Container(
    //       padding: padding,
    //       alignment: Alignment.center,
    //       child: const Text(
    //         'Ações',
    //       ),
    //     ),
    //   ),
    // );
  }
}
