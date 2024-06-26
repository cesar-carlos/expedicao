import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoSepararItemModel {
  final int codEmpresa;
  final int codSepararEstoque;
  final String item;
  final int? codSetorEstoque;
  final String origem;
  final int codOrigem;
  final String? itemOrigem;
  final int codLocalArmazenagem;
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
    required this.codLocalArmazenagem,
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
    int? codLocalArmazenagem,
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
      codLocalArmazenagem: codLocalArmazenagem ?? this.codLocalArmazenagem,
      codProduto: codProduto ?? this.codProduto,
      codUnidadeMedida: codUnidadeMedida ?? this.codUnidadeMedida,
      quantidade: quantidade ?? this.quantidade,
      quantidadeInterna: quantidadeInterna ?? this.quantidadeInterna,
      quantidadeExterna: quantidadeExterna ?? this.quantidadeExterna,
      quantidadeSeparacao: quantidadeSeparacao ?? this.quantidadeSeparacao,
    );
  }

  factory ExpedicaoSepararItemModel.fromJson(Map<String, dynamic> json) {
    try {
      return ExpedicaoSepararItemModel(
        codEmpresa: json['CodEmpresa'],
        codSepararEstoque: json['CodSepararEstoque'],
        item: json['Item'],
        codSetorEstoque: json['CodSetorEstoque'],
        origem: json['Origem'],
        codOrigem: json['CodOrigem'],
        itemOrigem: json['ItemOrigem'],
        codLocalArmazenagem: json['CodLocalArmazenagem'],
        codProduto: json['CodProduto'],
        codUnidadeMedida: json['CodUnidadeMedida'],
        quantidade: AppHelper.stringToDouble(json['Quantidade']),
        quantidadeInterna: AppHelper.stringToDouble(json['QuantidadeInterna']),
        quantidadeExterna: AppHelper.stringToDouble(json['QuantidadeExterna']),
        quantidadeSeparacao:
            AppHelper.stringToDouble(json['QuantidadeSeparacao']),
      );
    } catch (_) {
      rethrow;
    }
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
    data['CodLocalArmazenagem'] = codLocalArmazenagem;
    data['CodProduto'] = codProduto;
    data['CodUnidadeMedida'] = codUnidadeMedida;
    data['Quantidade'] = quantidade.toStringAsFixed(4);
    data['QuantidadeInterna'] = quantidadeInterna.toStringAsFixed(4);
    data['QuantidadeExterna'] = quantidadeExterna.toStringAsFixed(4);
    data['QuantidadeSeparacao'] = quantidadeSeparacao.toStringAsFixed(4);
    return data;
  }

  @override
  String toString() {
    return '''
      ExpedicaoSepararItemModel(
        codEmpresa: $codEmpresa, 
        codSepararEstoque: $codSepararEstoque, 
        item: $item, 
        codSetorEstoque: $codSetorEstoque, 
        origem: $origem, 
        codOrigem: $codOrigem, 
        itemOrigem: $itemOrigem, 
        codLocalArmazenagem: $codLocalArmazenagem, 
        codProduto: $codProduto, 
        codUnidadeMedida: $codUnidadeMedida, 
        quantidade: $quantidade, 
        quantidadeInterna: $quantidadeInterna, 
        quantidadeExterna: $quantidadeExterna, 
        quantidadeSeparacao: $quantidadeSeparacao
    )''';
  }
}
