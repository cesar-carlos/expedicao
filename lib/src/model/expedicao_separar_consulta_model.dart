import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoSepararConsultaModel {
  final int codEmpresa;
  final int codSepararEstoque;
  final int codTipoOperacao;
  final String nomeTipoOperacao;
  final String situacao;
  final String tipoEntidade;
  final DateTime dataEmissao;
  final String horaEmissao;
  final int codEntidade;
  final String nomeEntidade;
  final int codPrioridade;
  final String nomePrioridade;
  final int? historico;
  final int? observacao;

  ExpedicaoSepararConsultaModel({
    required this.codEmpresa,
    required this.codSepararEstoque,
    required this.codTipoOperacao,
    required this.nomeTipoOperacao,
    required this.situacao,
    required this.tipoEntidade,
    required this.dataEmissao,
    required this.horaEmissao,
    required this.codEntidade,
    required this.nomeEntidade,
    required this.codPrioridade,
    required this.nomePrioridade,
    required this.historico,
    required this.observacao,
  });

  factory ExpedicaoSepararConsultaModel.fromJson(Map<String, dynamic> map) {
    return ExpedicaoSepararConsultaModel(
      codEmpresa: map['CodEmpresa'],
      codSepararEstoque: map['CodSepararEstoque'],
      codTipoOperacao: map['CodTipoOperacaoExpedicao'],
      nomeTipoOperacao: map['NomeTipoOperacaoExpedicao'],
      situacao: map['Situacao'],
      tipoEntidade: map['TipoEntidade'],
      dataEmissao: AppHelper.tryStringToDate(map['DataEmissao']),
      horaEmissao: map['HoraEmissao'],
      codEntidade: map['CodEntidade'],
      nomeEntidade: map['NomeEntidade'],
      codPrioridade: map['CodPrioridade'],
      nomePrioridade: map['NomePrioridade'],
      historico: map['Historico'],
      observacao: map['Observacao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodSepararEstoque': codSepararEstoque,
      'CodTipoOperacaoExpedicao': codTipoOperacao,
      'NomeTipoOperacaoExpedicao': nomeTipoOperacao,
      'Situacao': situacao,
      'TipoEntidade': tipoEntidade,
      'DataEmissao': dataEmissao,
      'HoraEmissao': horaEmissao,
      'CodEntidade': codEntidade,
      'NomeEntidade': nomeEntidade,
      'CodPrioridade': codPrioridade,
      'NomePrioridade': nomePrioridade,
      'Historico': historico,
      'Observacao': observacao,
    };
  }

  @override
  String toString() {
    return 'ExpedicaoSepararConsultaModel(codEmpresa: $codEmpresa, codSepararEstoque: $codSepararEstoque, codTipoOperacao: $codTipoOperacao, nomeTipoOperacao: $nomeTipoOperacao, situacao: $situacao, tipoEntidade: $tipoEntidade, dataEmissao: $dataEmissao, horaEmissao: $horaEmissao, codEntidade: $codEntidade, nomeEntidade: $nomeEntidade, codPrioridade: $codPrioridade, nomePrioridade: $nomePrioridade, historico: $historico, observacao: $observacao)';
  }
}
