import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoConferirItemModel {
  final int codEmpresa;
  final int codConferir;
  final String item;
  final int codCarrinhoPercurso;
  final String itemCarrinhoPercurso;
  final int codProduto;
  final String codUnidadeMedida;
  final double quantidade;
  final double quantidadeConferida;

  ExpedicaoConferirItemModel({
    required this.codEmpresa,
    required this.codConferir,
    required this.item,
    required this.codCarrinhoPercurso,
    required this.itemCarrinhoPercurso,
    required this.codProduto,
    required this.codUnidadeMedida,
    required this.quantidade,
    required this.quantidadeConferida,
  });

  ExpedicaoConferirItemModel copyWith({
    int? codEmpresa,
    int? codConferir,
    String? item,
    int? codCarrinhoPercurso,
    String? itemCarrinhoPercurso,
    int? codProduto,
    String? codUnidadeMedida,
    double? quantidade,
    double? quantidadeConferida,
  }) {
    return ExpedicaoConferirItemModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codConferir: codConferir ?? this.codConferir,
      item: item ?? this.item,
      codCarrinhoPercurso: codCarrinhoPercurso ?? this.codCarrinhoPercurso,
      itemCarrinhoPercurso: itemCarrinhoPercurso ?? this.itemCarrinhoPercurso,
      codProduto: codProduto ?? this.codProduto,
      codUnidadeMedida: codUnidadeMedida ?? this.codUnidadeMedida,
      quantidade: quantidade ?? this.quantidade,
      quantidadeConferida: quantidadeConferida ?? this.quantidadeConferida,
    );
  }

  factory ExpedicaoConferirItemModel.fromJson(Map<String, dynamic> map) {
    return ExpedicaoConferirItemModel(
      codEmpresa: map['CodEmpresa'],
      codConferir: map['CodConferir'],
      item: map['Item'],
      codCarrinhoPercurso: map['CodCarrinhoPercurso'],
      itemCarrinhoPercurso: map['ItemCarrinhoPercurso'],
      codProduto: map['CodProduto'],
      codUnidadeMedida: map['CodUnidadeMedida'],
      quantidade: AppHelper.stringToDouble(map['Quantidade']),
      quantidadeConferida: AppHelper.stringToDouble(map['QuantidadeConferida']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CodEmpresa'] = codEmpresa;
    data['CodConferir'] = codConferir;
    data['Item'] = item;
    data['CodCarrinhoPercurso'] = codCarrinhoPercurso;
    data['ItemCarrinhoPercurso'] = itemCarrinhoPercurso;
    data['CodProduto'] = codProduto;
    data['CodUnidadeMedida'] = codUnidadeMedida;
    data['Quantidade'] = quantidade.toStringAsFixed(4);
    data['QuantidadeConferida'] = quantidadeConferida.toStringAsFixed(4);
    return data;
  }
}
