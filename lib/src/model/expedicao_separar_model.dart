import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoSepararModel {
  final int codEmpresa;
  final int codSepararEstoque;
  final int codTipoOperacaoExpedicao;
  final String tipoEntidade;
  final int codEntidade;
  final String nomeEntidade;
  final String situacao;
  final DateTime data;
  final String hora;
  final int codPrioridade;
  final String? historico;
  final String? observacao;
  final int? codMotivoCancelamento;
  final DateTime? dataCancelamento;
  final String? horaCancelamento;
  final int? codUsuarioCancelamento;
  final String? nomeUsuarioCancelamento;
  final String? observacaoCancelamento;

  ExpedicaoSepararModel({
    required this.codEmpresa,
    required this.codSepararEstoque,
    required this.codTipoOperacaoExpedicao,
    required this.tipoEntidade,
    required this.codEntidade,
    required this.nomeEntidade,
    required this.situacao,
    required this.data,
    required this.hora,
    required this.codPrioridade,
    this.historico,
    this.observacao,
    this.codMotivoCancelamento,
    this.dataCancelamento,
    this.horaCancelamento,
    this.codUsuarioCancelamento,
    this.nomeUsuarioCancelamento,
    this.observacaoCancelamento,
  });

  factory ExpedicaoSepararModel.fromJson(Map map) {
    return ExpedicaoSepararModel(
      codEmpresa: map['CodEmpresa'],
      codSepararEstoque: map['CodSepararEstoque'],
      codTipoOperacaoExpedicao: map['CodTipoOperacaoExpedicao'],
      tipoEntidade: map['TipoEntidade'],
      codEntidade: map['CodEntidade'],
      nomeEntidade: map['NomeEntidade'],
      situacao: map['Situacao'],
      data: AppHelper.tryStringToDate(map['Data']),
      hora: map['Hora'] ?? '00:00:00',
      codPrioridade: map['CodPrioridade'],
      historico: map['Historico'],
      observacao: map['Observacao'],
      codMotivoCancelamento: map['CodMotivoCancelamento'],
      dataCancelamento: map['DataCancelamento'],
      horaCancelamento: map['HoraCancelamento'],
      codUsuarioCancelamento: map['CodUsuarioCancelamento'],
      nomeUsuarioCancelamento: map['NomeUsuarioCancelamento'],
      observacaoCancelamento: map['ObservacaoCancelamento'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "CodEmpresa": codEmpresa,
      "CodSepararEstoque": codSepararEstoque,
      "CodTipoOperacaoExpedicao": codTipoOperacaoExpedicao,
      "TipoEntidade": tipoEntidade,
      "CodEntidade": codEntidade,
      "NomeEntidade": nomeEntidade,
      "Situacao": situacao,
      "Data": data.toIso8601String(),
      "Hora": hora,
      "CodPrioridade": codPrioridade,
      "Historico": historico,
      "Observacao": observacao,
      "CodMotivoCancelamento": codMotivoCancelamento,
      "DataCancelamento": dataCancelamento,
      "HoraCancelamento": horaCancelamento,
      "CodUsuarioCancelamento": codUsuarioCancelamento,
      "NomeUsuarioCancelamento": nomeUsuarioCancelamento,
      "ObservacaoCancelamento": observacaoCancelamento,
    };
  }
}
