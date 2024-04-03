import 'package:app_expedicao/src/app/app_helper.dart';
import 'package:app_expedicao/src/model/expedicao_conferencia_item_consulta_model.dart';

class ExpedicaoConferenciaItemModel {
  final int codEmpresa;
  final int codConferir;
  final String item;
  final String sessionId;
  final String situacao;
  final int codCarrinhoPercurso;
  final String itemCarrinhoPercurso;
  final int codConferente;
  final String nomeConferente;
  final DateTime dataConferencia;
  final String horaConferencia;
  final int codProduto;
  final String codUnidadeMedida;
  final double quantidade;

  ExpedicaoConferenciaItemModel({
    required this.codEmpresa,
    required this.codConferir,
    required this.item,
    required this.sessionId,
    required this.situacao,
    required this.codCarrinhoPercurso,
    required this.itemCarrinhoPercurso,
    required this.codConferente,
    required this.nomeConferente,
    required this.dataConferencia,
    required this.horaConferencia,
    required this.codProduto,
    required this.codUnidadeMedida,
    required this.quantidade,
  });

  ExpedicaoConferenciaItemModel copyWith({
    int? codEmpresa,
    int? codConferir,
    String? item,
    String? sessionId,
    String? situacao,
    int? codCarrinhoPercurso,
    String? itemCarrinhoPercurso,
    int? codConferente,
    String? nomeConferente,
    DateTime? dataConferencia,
    String? horaConferencia,
    int? codProduto,
    String? codUnidadeMedida,
    double? quantidade,
  }) {
    return ExpedicaoConferenciaItemModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codConferir: codConferir ?? this.codConferir,
      item: item ?? this.item,
      sessionId: sessionId ?? this.sessionId,
      situacao: situacao ?? this.situacao,
      codCarrinhoPercurso: codCarrinhoPercurso ?? this.codCarrinhoPercurso,
      itemCarrinhoPercurso: itemCarrinhoPercurso ?? this.itemCarrinhoPercurso,
      codConferente: codConferente ?? this.codConferente,
      nomeConferente: nomeConferente ?? this.nomeConferente,
      dataConferencia: dataConferencia ?? this.dataConferencia,
      horaConferencia: horaConferencia ?? this.horaConferencia,
      codProduto: codProduto ?? this.codProduto,
      codUnidadeMedida: codUnidadeMedida ?? this.codUnidadeMedida,
      quantidade: quantidade ?? this.quantidade,
    );
  }

  factory ExpedicaoConferenciaItemModel.fromConsulta(
      ExpedicaConferenciaItemConsultaModel model) {
    return ExpedicaoConferenciaItemModel(
      codEmpresa: model.codEmpresa,
      codConferir: model.codConferir,
      item: model.item,
      sessionId: model.sessionId,
      situacao: model.situacao,
      codCarrinhoPercurso: model.codCarrinhoPercurso,
      itemCarrinhoPercurso: model.itemCarrinhoPercurso,
      codConferente: model.codConferente,
      nomeConferente: model.nomeConferente,
      dataConferencia: model.dataConferencia,
      horaConferencia: model.horaConferencia,
      codProduto: model.codProduto,
      codUnidadeMedida: model.codUnidadeMedida,
      quantidade: model.quantidade,
    );
  }

  factory ExpedicaoConferenciaItemModel.fromJson(Map<String, dynamic> json) {
    try {
      return ExpedicaoConferenciaItemModel(
        codEmpresa: json['CodEmpresa'],
        codConferir: json['CodConferir'],
        item: json['Item'],
        sessionId: json['SessionId'],
        situacao: json['Situacao'],
        codCarrinhoPercurso: json['CodCarrinhoPercurso'],
        itemCarrinhoPercurso: json['ItemCarrinhoPercurso'],
        codConferente: json['CodConferente'],
        nomeConferente: json['NomeConferente'],
        dataConferencia: AppHelper.tryStringToDate(json['DataConferencia']),
        horaConferencia: json['HoraConferencia'],
        codProduto: json['CodProduto'],
        codUnidadeMedida: json['CodUnidadeMedida'],
        quantidade: AppHelper.stringToDouble(json['Quantidade']),
      );
    } catch (_) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodConferir': codConferir,
      'Item': item,
      'SessionId': sessionId,
      'Situacao': situacao,
      'CodCarrinhoPercurso': codCarrinhoPercurso,
      'ItemCarrinhoPercurso': itemCarrinhoPercurso,
      'CodConferente': codConferente,
      'NomeConferente': nomeConferente,
      'DataConferencia': dataConferencia.toIso8601String(),
      'HoraConferencia': horaConferencia,
      'CodProduto': codProduto,
      'CodUnidadeMedida': codUnidadeMedida,
      'Quantidade': quantidade.toStringAsFixed(4),
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaoConferenciaItemModel(
        codEmpresa: $codEmpresa, 
        codConferir: $codConferir, 
        item: $item, 
        sessionId: $sessionId, 
        situacao: $situacao, 
        codCarrinhoPercurso: $codCarrinhoPercurso, 
        itemCarrinhoPercurso: $itemCarrinhoPercurso, 
        codConferente: $codConferente, 
        nomeConferente: $nomeConferente, 
        dataConferencia: $dataConferencia, 
        horaConferencia: $horaConferencia, 
        codProduto: $codProduto, 
        codUnidadeMedida: $codUnidadeMedida, 
        quantidade: $quantidade
    )''';
  }
}
