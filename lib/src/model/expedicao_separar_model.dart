import 'package:app_expedicao/src/app/app_helper.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';

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

  ExpedicaoSepararModel copyWith({
    int? codEmpresa,
    int? codSepararEstoque,
    int? codTipoOperacaoExpedicao,
    String? tipoEntidade,
    int? codEntidade,
    String? nomeEntidade,
    String? situacao,
    DateTime? data,
    String? hora,
    int? codPrioridade,
    String? historico,
    String? observacao,
    int? codMotivoCancelamento,
    DateTime? dataCancelamento,
    String? horaCancelamento,
    int? codUsuarioCancelamento,
    String? nomeUsuarioCancelamento,
    String? observacaoCancelamento,
  }) {
    return ExpedicaoSepararModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codSepararEstoque: codSepararEstoque ?? this.codSepararEstoque,
      codTipoOperacaoExpedicao:
          codTipoOperacaoExpedicao ?? this.codTipoOperacaoExpedicao,
      tipoEntidade: tipoEntidade ?? this.tipoEntidade,
      codEntidade: codEntidade ?? this.codEntidade,
      nomeEntidade: nomeEntidade ?? this.nomeEntidade,
      situacao: situacao ?? this.situacao,
      data: data ?? this.data,
      hora: hora ?? this.hora,
      codPrioridade: codPrioridade ?? this.codPrioridade,
      historico: historico ?? this.historico,
      observacao: observacao ?? this.observacao,
      codMotivoCancelamento:
          codMotivoCancelamento ?? this.codMotivoCancelamento,
      dataCancelamento: dataCancelamento ?? this.dataCancelamento,
      horaCancelamento: horaCancelamento ?? this.horaCancelamento,
      codUsuarioCancelamento:
          codUsuarioCancelamento ?? this.codUsuarioCancelamento,
      nomeUsuarioCancelamento:
          nomeUsuarioCancelamento ?? this.nomeUsuarioCancelamento,
      observacaoCancelamento:
          observacaoCancelamento ?? this.observacaoCancelamento,
    );
  }

  factory ExpedicaoSepararModel.fromConsulta(
      ExpedicaoSepararConsultaModel model) {
    return ExpedicaoSepararModel(
      codEmpresa: model.codEmpresa,
      codSepararEstoque: model.codSepararEstoque,
      codTipoOperacaoExpedicao: model.codTipoOperacao,
      tipoEntidade: model.tipoEntidade,
      codEntidade: model.codEntidade,
      nomeEntidade: model.nomeEntidade,
      situacao: model.situacao,
      data: model.dataEmissao,
      hora: model.horaEmissao,
      codPrioridade: model.codPrioridade,
      historico: model.historico,
      observacao: model.observacao,
    );
  }

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
      dataCancelamento:
          AppHelper.tryStringToDateOrNull(map['DataCancelamento']),
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
      if (historico != null) "Historico": historico,
      if (observacao != null) "Observacao": observacao,
      "CodMotivoCancelamento": codMotivoCancelamento,
      "DataCancelamento": dataCancelamento?.toIso8601String(),
      "HoraCancelamento": horaCancelamento,
      "CodUsuarioCancelamento": codUsuarioCancelamento,
      "NomeUsuarioCancelamento": nomeUsuarioCancelamento,
      "ObservacaoCancelamento": observacaoCancelamento,
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaoSepararModel(
        codEmpresa: $codEmpresa, 
        codSepararEstoque: $codSepararEstoque, 
        codTipoOperacaoExpedicao: $codTipoOperacaoExpedicao, 
        tipoEntidade: $tipoEntidade, 
        codEntidade: $codEntidade, 
        nomeEntidade: $nomeEntidade, 
        situacao: $situacao, 
        data: $data, 
        hora: $hora, 
        codPrioridade: $codPrioridade, 
        historico: $historico, 
        observacao: $observacao, 
        codMotivoCancelamento: $codMotivoCancelamento, 
        dataCancelamento: $dataCancelamento, 
        horaCancelamento: $horaCancelamento, 
        codUsuarioCancelamento: $codUsuarioCancelamento, 
        nomeUsuarioCancelamento: $nomeUsuarioCancelamento, 
        observacaoCancelamento: $observacaoCancelamento)
      ''';
  }
}
