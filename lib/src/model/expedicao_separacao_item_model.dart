import 'package:app_expedicao/src/app/app_helper.dart';
import 'package:app_expedicao/src/model/expedicao_separacao_item_consulta_model.dart';

class ExpedicaoSeparacaoItemModel {
  final int codEmpresa;
  final int codSepararEstoque;
  final String item;
  final String sessionId;
  final String situacao;
  final int codCarrinhoPercurso;
  final String itemCarrinhoPercurso;
  final int codSeparador;
  final String nomeSeparador;
  final DateTime dataSeparacao;
  final String horaSeparacao;
  final int codProduto;
  final String codUnidadeMedida;
  final double quantidade;

  ExpedicaoSeparacaoItemModel({
    required this.codEmpresa,
    required this.codSepararEstoque,
    required this.item,
    required this.sessionId,
    required this.situacao,
    required this.codCarrinhoPercurso,
    required this.itemCarrinhoPercurso,
    required this.codSeparador,
    required this.nomeSeparador,
    required this.dataSeparacao,
    required this.horaSeparacao,
    required this.codProduto,
    required this.codUnidadeMedida,
    required this.quantidade,
  });

  ExpedicaoSeparacaoItemModel copyWith({
    int? codEmpresa,
    int? codSepararEstoque,
    String? item,
    String? sessionId,
    String? situacao,
    int? codCarrinhoPercurso,
    String? itemCarrinhoPercurso,
    int? codSeparador,
    String? nomeSeparador,
    DateTime? dataSeparacao,
    String? horaSeparacao,
    int? codProduto,
    String? codUnidadeMedida,
    double? quantidade,
  }) {
    return ExpedicaoSeparacaoItemModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codSepararEstoque: codSepararEstoque ?? this.codSepararEstoque,
      item: item ?? this.item,
      sessionId: sessionId ?? this.sessionId,
      situacao: situacao ?? this.situacao,
      codCarrinhoPercurso: codCarrinhoPercurso ?? this.codCarrinhoPercurso,
      itemCarrinhoPercurso: itemCarrinhoPercurso ?? this.itemCarrinhoPercurso,
      codSeparador: codSeparador ?? this.codSeparador,
      nomeSeparador: nomeSeparador ?? this.nomeSeparador,
      dataSeparacao: dataSeparacao ?? this.dataSeparacao,
      horaSeparacao: horaSeparacao ?? this.horaSeparacao,
      codProduto: codProduto ?? this.codProduto,
      codUnidadeMedida: codUnidadeMedida ?? this.codUnidadeMedida,
      quantidade: quantidade ?? this.quantidade,
    );
  }

  factory ExpedicaoSeparacaoItemModel.fromConsulta(
      ExpedicaSeparacaoItemConsultaModel model) {
    return ExpedicaoSeparacaoItemModel(
      codEmpresa: model.codEmpresa,
      codSepararEstoque: model.codSepararEstoque,
      item: model.item,
      sessionId: model.sessionId,
      situacao: model.situacao,
      codCarrinhoPercurso: model.codCarrinhoPercurso,
      itemCarrinhoPercurso: model.itemCarrinhoPercurso,
      codSeparador: model.codSeparador,
      nomeSeparador: model.nomeSeparador,
      dataSeparacao: model.dataSeparacao,
      horaSeparacao: model.horaSeparacao,
      codProduto: model.codProduto,
      codUnidadeMedida: model.codUnidadeMedida,
      quantidade: model.quantidade,
    );
  }

  factory ExpedicaoSeparacaoItemModel.fromJson(Map<String, dynamic> json) {
    try {
      return ExpedicaoSeparacaoItemModel(
        codEmpresa: json['CodEmpresa'],
        codSepararEstoque: json['CodSepararEstoque'],
        item: json['Item'],
        sessionId: json['SessionId'],
        situacao: json['Situacao'],
        codCarrinhoPercurso: json['CodCarrinhoPercurso'],
        itemCarrinhoPercurso: json['ItemCarrinhoPercurso'],
        codSeparador: json['CodSeparador'],
        nomeSeparador: json['NomeSeparador'],
        dataSeparacao: AppHelper.tryStringToDate(json['DataSeparacao']),
        horaSeparacao: json['HoraSeparacao'] ?? '00:00:00',
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
      "CodEmpresa": codEmpresa,
      "CodSepararEstoque": codSepararEstoque,
      "Item": item,
      "SessionId": sessionId,
      "Situacao": situacao,
      "CodCarrinhoPercurso": codCarrinhoPercurso,
      "ItemCarrinhoPercurso": itemCarrinhoPercurso,
      "CodSeparador": codSeparador,
      "NomeSeparador": nomeSeparador,
      "DataSeparacao": dataSeparacao.toIso8601String(),
      "HoraSeparacao": horaSeparacao,
      "CodProduto": codProduto,
      "CodUnidadeMedida": codUnidadeMedida,
      "Quantidade": quantidade.toStringAsFixed(4),
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaoSeparacaoItemModel(
        codEmpresa: $codEmpresa, 
        codSepararEstoque: $codSepararEstoque, 
        item: $item, 
        sessionId: $sessionId, 
        situacao: $situacao, 
        codCarrinhoPercurso: $codCarrinhoPercurso, 
        itemCarrinhoPercurso: $itemCarrinhoPercurso, 
        codSeparador: $codSeparador, 
        nomeSeparador: $nomeSeparador, 
        dataSeparacao: $dataSeparacao, 
        horaSeparacao: $horaSeparacao, 
        codProduto: $codProduto, 
        codUnidadeMedida: $codUnidadeMedida, 
        quantidade: $quantidade
    )''';
  }
}
