import 'package:app_expedicao/src/app/app_helper.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_consulta_model.dart';

class ExpedicaoConferirModel {
  final int codEmpresa;
  final int codConferir;
  final String origem;
  final int codOrigem;
  final int codPrioridade;
  final String situacao;
  final DateTime data;
  final String hora;
  final String? historico;
  final String? observacao;
  final int? codMotivoCancelamento;
  final DateTime? dataCancelamento;
  final String? horaCancelamento;
  final int? codUsuarioCancelamento;
  final String? nomeUsuarioCancelamento;
  final String? observacaoCancelamento;

  ExpedicaoConferirModel({
    required this.codEmpresa,
    required this.codConferir,
    required this.origem,
    required this.codOrigem,
    required this.codPrioridade,
    required this.situacao,
    required this.data,
    required this.hora,
    this.historico,
    this.observacao,
    this.codMotivoCancelamento,
    this.dataCancelamento,
    this.horaCancelamento,
    this.codUsuarioCancelamento,
    this.nomeUsuarioCancelamento,
    this.observacaoCancelamento,
  });

  ExpedicaoConferirModel copyWith({
    int? codEmpresa,
    int? codConferir,
    String? origem,
    int? codOrigem,
    int? codPrioridade,
    String? situacao,
    DateTime? data,
    String? hora,
    String? historico,
    String? observacao,
    int? codMotivoCancelamento,
    DateTime? dataCancelamento,
    String? horaCancelamento,
    int? codUsuarioCancelamento,
    String? nomeUsuarioCancelamento,
    String? observacaoCancelamento,
  }) {
    return ExpedicaoConferirModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codConferir: codConferir ?? this.codConferir,
      origem: origem ?? this.origem,
      codOrigem: codOrigem ?? this.codOrigem,
      codPrioridade: codPrioridade ?? this.codPrioridade,
      situacao: situacao ?? this.situacao,
      data: data ?? this.data,
      hora: hora ?? this.hora,
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

  factory ExpedicaoConferirModel.fromConsulta(
      ExpedicaoConferirConsultaModel model) {
    return ExpedicaoConferirModel(
      codEmpresa: model.codEmpresa,
      codConferir: model.codConferir,
      origem: model.origem,
      codOrigem: model.codOrigem,
      codPrioridade: model.codPrioridade,
      situacao: model.situacao,
      data: model.data,
      hora: model.hora,
      historico: model.historico,
      observacao: model.observacao,
    );
  }

  factory ExpedicaoConferirModel.fromJson(Map map) {
    return ExpedicaoConferirModel(
      codEmpresa: map['CodEmpresa'],
      codConferir: map['CodConferir'],
      origem: map['Origem'],
      codOrigem: map['CodOrigem'],
      codPrioridade: map['CodPrioridade'],
      situacao: map['Situacao'],
      data: AppHelper.tryStringToDate(map['Data']),
      hora: map['Hora'],
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
      "CodConferir": codConferir,
      "Origem": origem,
      "CodOrigem": codOrigem,
      "CodPrioridade": codPrioridade,
      "Situacao": situacao,
      "Data": data.toIso8601String(),
      "Hora": hora,
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
      ExpedicaoConferirModel(
        codEmpresa: $codEmpresa, 
        codConferir: $codConferir, 
        origem: $origem, 
        codOrigem: $codOrigem, 
        codPrioridade: $codPrioridade, 
        situacao: $situacao, 
        data: $data, 
        hora: $hora, 
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
