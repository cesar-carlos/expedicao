import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoSepararItemModel {
  final int codEmpresa;
  final int codSepararEstoque;
  final String item;
  final int? codSetorEstoque;
  final String origem;
  final int codOrigem;
  final String? itemOrigem;
  final int codLocaArmazenagem;
  final int codProduto;
  final String codUnidadeMedida;
  final double quantidade;
  final double quantidadeInterna;
  final double quantidadeExterna;
  final double quantidadeSeparacao;

  ExpedicaoSepararItemModel({
    required this.codEmpresa,
    required this.codSepararEstoque,
    required this.item,
    this.codSetorEstoque,
    required this.origem,
    required this.codOrigem,
    this.itemOrigem,
    required this.codLocaArmazenagem,
    required this.codProduto,
    required this.codUnidadeMedida,
    required this.quantidade,
    required this.quantidadeInterna,
    required this.quantidadeExterna,
    required this.quantidadeSeparacao,
  });

  ExpedicaoSepararItemModel copyWith({
    int? codEmpresa,
    int? codSepararEstoque,
    String? item,
    int? codSetorEstoque,
    String? origem,
    int? codOrigem,
    String? itemOrigem,
    int? codLocaArmazenagem,
    int? codProduto,
    String? codUnidadeMedida,
    double? quantidade,
    double? quantidadeInterna,
    double? quantidadeExterna,
    double? quantidadeSeparacao,
  }) {
    return ExpedicaoSepararItemModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codSepararEstoque: codSepararEstoque ?? this.codSepararEstoque,
      item: item ?? this.item,
      codSetorEstoque: codSetorEstoque ?? this.codSetorEstoque,
      origem: origem ?? this.origem,
      codOrigem: codOrigem ?? this.codOrigem,
      itemOrigem: itemOrigem ?? this.itemOrigem,
      codLocaArmazenagem: codLocaArmazenagem ?? this.codLocaArmazenagem,
      codProduto: codProduto ?? this.codProduto,
      codUnidadeMedida: codUnidadeMedida ?? this.codUnidadeMedida,
      quantidade: quantidade ?? this.quantidade,
      quantidadeInterna: quantidadeInterna ?? this.quantidadeInterna,
      quantidadeExterna: quantidadeExterna ?? this.quantidadeExterna,
      quantidadeSeparacao: quantidadeSeparacao ?? this.quantidadeSeparacao,
    );
  }

  factory ExpedicaoSepararItemModel.fromJson(Map<String, dynamic> map) {
    return ExpedicaoSepararItemModel(
      codEmpresa: map['CodEmpresa'],
      codSepararEstoque: map['CodSepararEstoque'],
      item: map['Item'],
      codSetorEstoque: map['CodSetorEstoque'],
      origem: map['Origem'],
      codOrigem: map['CodOrigem'],
      itemOrigem: map['ItemOrigem'],
      codLocaArmazenagem: map['CodLocaArmazenagem'],
      codProduto: map['CodProduto'],
      codUnidadeMedida: map['CodUnidadeMedida'],
      quantidade: AppHelper.stringToDouble(map['Quantidade']),
      quantidadeInterna: AppHelper.stringToDouble(map['QuantidadeInterna']),
      quantidadeExterna: AppHelper.stringToDouble(map['QuantidadeExterna']),
      quantidadeSeparacao: AppHelper.stringToDouble(map['QuantidadeSeparacao']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CodEmpresa'] = codEmpresa;
    data['CodSepararEstoque'] = codSepararEstoque;
    data['Item'] = item;
    data['CodSetorEstoque'] = codSetorEstoque;
    data['Origem'] = origem;
    data['CodOrigem'] = codOrigem;
    data['ItemOrigem'] = itemOrigem;
    data['CodLocaArmazenagem'] = codLocaArmazenagem;
    data['CodProduto'] = codProduto;
    data['CodUnidadeMedida'] = codUnidadeMedida;
    data['Quantidade'] = quantidade.toStringAsFixed(4);
    data['QuantidadeInterna'] = quantidadeInterna.toStringAsFixed(4);
    data['QuantidadeExterna'] = quantidadeExterna.toStringAsFixed(4);
    data['QuantidadeSeparacao'] = quantidadeSeparacao.toStringAsFixed(4);
    return data;
  }
}
