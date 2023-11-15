import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoSeparacaoItemModel {
  final int codEmpresa;
  final int codSepararEstoque;
  final String item;
  final String sessionId;
  final int codCarrinho;
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
    required this.codCarrinho,
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
    int? codCarrinho,
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
      codCarrinho: codCarrinho ?? this.codCarrinho,
      codSeparador: codSeparador ?? this.codSeparador,
      nomeSeparador: nomeSeparador ?? this.nomeSeparador,
      dataSeparacao: dataSeparacao ?? this.dataSeparacao,
      horaSeparacao: horaSeparacao ?? this.horaSeparacao,
      codProduto: codProduto ?? this.codProduto,
      codUnidadeMedida: codUnidadeMedida ?? this.codUnidadeMedida,
      quantidade: quantidade ?? this.quantidade,
    );
  }

  factory ExpedicaoSeparacaoItemModel.fromJson(Map<String, dynamic> map) {
    return ExpedicaoSeparacaoItemModel(
      codEmpresa: map['CodEmpresa'],
      codSepararEstoque: map['CodSepararEstoque'],
      item: map['Item'],
      sessionId: map['SessionId'],
      codCarrinho: map['CodCarrinho'],
      codSeparador: map['CodSeparador'],
      nomeSeparador: map['NomeSeparador'],
      dataSeparacao: AppHelper.tryStringToDate(map['DataSeparacao']),
      horaSeparacao: map['HoraSeparacao'] ?? '00:00:00',
      codProduto: map['CodProduto'],
      codUnidadeMedida: map['CodUnidadeMedida'],
      quantidade: AppHelper.stringToDouble(map['Quantidade']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "CodEmpresa": codEmpresa,
      "CodSepararEstoque": codSepararEstoque,
      "Item": item,
      "SessionId": sessionId,
      "CodCarrinho": codCarrinho,
      "CodSeparador": codSeparador,
      "NomeSeparador": nomeSeparador,
      "DataSeparacao": dataSeparacao.toIso8601String(),
      "HoraSeparacao": horaSeparacao,
      "CodProduto": codProduto,
      "CodUnidadeMedida": codUnidadeMedida,
      "Quantidade": quantidade,
    };
  }
}
