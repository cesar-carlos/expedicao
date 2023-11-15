import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoSepararConsultaModel {
  final int codEmpresa;
  final int codSepararEstoque;
  final int codTipoOperacaoExpedicao;
  final String tipoOperacaoExpedicao;
  final String tipoEntidade;
  final int codEntidade;
  final String nomeEntidade;
  final String situacao;
  final DateTime data;
  final String hora;
  final int codPrioridade;
  final String prioridade;
  final String historico;
  final String observacao;

  ExpedicaoSepararConsultaModel({
    required this.codEmpresa,
    required this.codSepararEstoque,
    required this.codTipoOperacaoExpedicao,
    required this.tipoOperacaoExpedicao,
    required this.tipoEntidade,
    required this.codEntidade,
    required this.nomeEntidade,
    required this.situacao,
    required this.data,
    required this.hora,
    required this.codPrioridade,
    required this.prioridade,
    required this.historico,
    required this.observacao,
  });

  factory ExpedicaoSepararConsultaModel.fromJson(Map map) {
    return ExpedicaoSepararConsultaModel(
      codEmpresa: map['CodEmpresa'],
      codSepararEstoque: map['CodSepararEstoque'],
      codTipoOperacaoExpedicao: map['CodTipoOperacaoExpedicao'],
      tipoOperacaoExpedicao: map['TipoOperacaoExpedicao'],
      tipoEntidade: map['TipoEntidade'],
      codEntidade: map['CodEntidade'],
      nomeEntidade: map['NomeEntidade'],
      situacao: map['Situacao'],
      data: AppHelper.tryStringToDate(map['Data']),
      hora: map['Hora'] ?? '00:00:00',
      codPrioridade: map['CodPrioridade'],
      prioridade: map['Prioridade'],
      historico: map['Historico'],
      observacao: map['Observacao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodSepararEstoque': codSepararEstoque,
      'CodTipoOperacaoExpedicao': codTipoOperacaoExpedicao,
      'TipoOperacaoExpedicao': tipoOperacaoExpedicao,
      'TipoEntidade': tipoEntidade,
      'CodEntidade': codEntidade,
      'NomeEntidade': nomeEntidade,
      'Situacao': situacao,
      'Data': data.toIso8601String(),
      'Hora': hora,
      'CodPrioridade': codPrioridade,
      'Prioridade': prioridade,
      'Historico': historico,
      'Observacao': observacao,
    };
  }
}
