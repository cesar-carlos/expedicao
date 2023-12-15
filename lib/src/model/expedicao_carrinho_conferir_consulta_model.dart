import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoCarrinhoConferirConsultaModel {
  final int codEmpresa;
  final int codConferir;
  final String origem;
  final int codOrigem;
  final String situacao;
  final int codCarrinhoPercurso;
  final String itemCarrinhoPercurso;
  final int codPrioridade;
  final String nomePrioridade;
  final int codCarrinho;
  final String nomeCarrinho;
  final String codigoBarrasCarrinho;
  String situacaoCarrinho;
  final DateTime dataInicioPercurso;
  final String horaInicioPercurso;
  final int codPercursoEstagio;
  final String nomePercursoEstagio;
  final int codUsuarioInicioEstagio;
  final String nomeUsuarioInicioEstagio;
  final DateTime dataInicioEstagio;
  final String horaInicioEstagio;
  final int codUsuarioFinalizacaoEstagio;
  final String nomeUsuarioFinalizacaoEstagio;
  final DateTime dataFinalizacaoEstagio;
  final String horaFinalizacaoEstagio;
  final double totalItemConferir;
  final double totalItemConferido;

  ExpedicaoCarrinhoConferirConsultaModel({
    required this.codEmpresa,
    required this.codConferir,
    required this.origem,
    required this.codOrigem,
    required this.situacao,
    required this.codCarrinhoPercurso,
    required this.itemCarrinhoPercurso,
    required this.codPrioridade,
    required this.nomePrioridade,
    required this.codCarrinho,
    required this.nomeCarrinho,
    required this.codigoBarrasCarrinho,
    required this.situacaoCarrinho,
    required this.dataInicioPercurso,
    required this.horaInicioPercurso,
    required this.codPercursoEstagio,
    required this.nomePercursoEstagio,
    required this.codUsuarioInicioEstagio,
    required this.nomeUsuarioInicioEstagio,
    required this.dataInicioEstagio,
    required this.horaInicioEstagio,
    required this.codUsuarioFinalizacaoEstagio,
    required this.nomeUsuarioFinalizacaoEstagio,
    required this.dataFinalizacaoEstagio,
    required this.horaFinalizacaoEstagio,
    required this.totalItemConferir,
    required this.totalItemConferido,
  });

  factory ExpedicaoCarrinhoConferirConsultaModel.fromJson(
      Map<String, dynamic> map) {
    return ExpedicaoCarrinhoConferirConsultaModel(
      codEmpresa: map['CodEmpresa'],
      codConferir: map['CodConferir'],
      origem: map['Origem'],
      codOrigem: map['CodOrigem'],
      situacao: map['Situacao'],
      codCarrinhoPercurso: map['CodCarrinhoPercurso'],
      itemCarrinhoPercurso: map['ItemCarrinhoPercurso'],
      codPrioridade: map['CodPrioridade'],
      nomePrioridade: map['NomePrioridade'],
      codCarrinho: map['CodCarrinho'],
      nomeCarrinho: map['NomeCarrinho'],
      codigoBarrasCarrinho: map['CodigoBarrasCarrinho'],
      situacaoCarrinho: map['SituacaoCarrinho'],
      dataInicioPercurso: AppHelper.tryStringToDate(map['DataInicioPercurso']),
      horaInicioPercurso: map['HoraInicioPercurso'],
      codPercursoEstagio: map['CodPercursoEstagio'],
      nomePercursoEstagio: map['NomePercursoEstagio'],
      codUsuarioInicioEstagio: map['CodUsuarioInicioEstagio'],
      nomeUsuarioInicioEstagio: map['NomeUsuarioInicioEstagio'],
      dataInicioEstagio: AppHelper.tryStringToDate(map['DataInicioEstagio']),
      horaInicioEstagio: map['HoraInicioEstagio'],
      codUsuarioFinalizacaoEstagio: map['CodUsuarioFinalizacaoEstagio'],
      nomeUsuarioFinalizacaoEstagio: map['NomeUsuarioFinalizacaoEstagio'],
      dataFinalizacaoEstagio:
          AppHelper.tryStringToDate(map['DataFinalizacaoEstagio']),
      horaFinalizacaoEstagio: map['HoraFinalizacaoEstagio'],
      totalItemConferir: AppHelper.stringToDouble(map['TotalItemConferir']),
      totalItemConferido: AppHelper.stringToDouble(map['TotalItemConferido']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodConferir': codConferir,
      'Origem': origem,
      'CodOrigem': codOrigem,
      'Situacao': situacao,
      'CodCarrinhoPercurso': codCarrinhoPercurso,
      'ItemCarrinhoPercurso': itemCarrinhoPercurso,
      'CodPrioridade': codPrioridade,
      'NomePrioridade': nomePrioridade,
      'CodCarrinho': codCarrinho,
      'NomeCarrinho': nomeCarrinho,
      'CodigoBarrasCarrinho': codigoBarrasCarrinho,
      'SituacaoCarrinho': situacaoCarrinho,
      'DataInicioPercurso': dataInicioPercurso.toIso8601String(),
      'HoraInicioPercurso': horaInicioPercurso,
      'CodPercursoEstagio': codPercursoEstagio,
      'NomePercursoEstagio': nomePercursoEstagio,
      'CodUsuarioInicioEstagio': codUsuarioInicioEstagio,
      'NomeUsuarioInicioEstagio': nomeUsuarioInicioEstagio,
      'DataInicioEstagio': dataInicioEstagio.toIso8601String(),
      'HoraInicioEstagio': horaInicioEstagio,
      'CodUsuarioFinalizacaoEstagio': codUsuarioFinalizacaoEstagio,
      'NomeUsuarioFinalizacaoEstagio': nomeUsuarioFinalizacaoEstagio,
      'DataFinalizacaoEstagio': dataFinalizacaoEstagio.toIso8601String(),
      'HoraFinalizacaoEstagio': horaFinalizacaoEstagio,
      'TotalItemConferir': totalItemConferir,
      'TotalItemConferido': totalItemConferido,
    };
  }

  @override
  String toString() {
    return 'ExpedicaoCarrinhoConferirConsultaModel(codEmpresa: $codEmpresa, codConferir: $codConferir, origem: $origem, codOrigem: $codOrigem, situacao: $situacao, codCarrinhoPercurso: $codCarrinhoPercurso, itemCarrinhoPercurso: $itemCarrinhoPercurso, codPrioridade: $codPrioridade, nomePrioridade: $nomePrioridade, codCarrinho: $codCarrinho, nomeCarrinho: $nomeCarrinho, codigoBarrasCarrinho: $codigoBarrasCarrinho, situacaoCarrinho: $situacaoCarrinho, dataInicioPercurso: $dataInicioPercurso, horaInicioPercurso: $horaInicioPercurso, codPercursoEstagio: $codPercursoEstagio, nomePercursoEstagio: $nomePercursoEstagio, codUsuarioInicioEstagio: $codUsuarioInicioEstagio, nomeUsuarioInicioEstagio: $nomeUsuarioInicioEstagio, dataInicioEstagio: $dataInicioEstagio, horaInicioEstagio: $horaInicioEstagio, codUsuarioFinalizacaoEstagio: $codUsuarioFinalizacaoEstagio, nomeUsuarioFinalizacaoEstagio: $nomeUsuarioFinalizacaoEstagio, dataFinalizacaoEstagio: $dataFinalizacaoEstagio, horaFinalizacaoEstagio: $horaFinalizacaoEstagio, totalItemConferir: $totalItemConferir, totalItemConferido: $totalItemConferido)';
  }
}
