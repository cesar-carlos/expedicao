import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoSepararItemUnidadeMedidaConsultaModel {
  final int codEmpresa;
  final int codSepararEstoque;
  final String item;
  final int codProduto;
  final String itemUnidadeMedida;
  final String codUnidadeMedida;
  final String unidadeMedidaDescricao;
  final String unidadeMedidaPadrao;
  final String tipoFatorConversao;
  final double fatorConversao;
  final String? codigoBarras;
  final String? observacao;

  ExpedicaoSepararItemUnidadeMedidaConsultaModel({
    required this.codEmpresa,
    required this.codSepararEstoque,
    required this.item,
    required this.codProduto,
    required this.itemUnidadeMedida,
    required this.codUnidadeMedida,
    required this.unidadeMedidaDescricao,
    required this.unidadeMedidaPadrao,
    required this.tipoFatorConversao,
    required this.fatorConversao,
    this.codigoBarras,
    this.observacao,
  });

  ExpedicaoSepararItemUnidadeMedidaConsultaModel copyWith({
    int? codEmpresa,
    int? codSepararEstoque,
    String? item,
    int? codProduto,
    String? itemUnidadeMedida,
    String? codUnidadeMedida,
    String? unidadeMedidaDescricao,
    String? unidadeMedidaPadrao,
    String? tipoFatorConversao,
    double? fatorConversao,
    String? codigoBarras,
    String? observacao,
  }) {
    return ExpedicaoSepararItemUnidadeMedidaConsultaModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codSepararEstoque: codSepararEstoque ?? this.codSepararEstoque,
      item: item ?? this.item,
      codProduto: codProduto ?? this.codProduto,
      itemUnidadeMedida: itemUnidadeMedida ?? this.itemUnidadeMedida,
      codUnidadeMedida: codUnidadeMedida ?? this.codUnidadeMedida,
      unidadeMedidaDescricao:
          unidadeMedidaDescricao ?? this.unidadeMedidaDescricao,
      unidadeMedidaPadrao: unidadeMedidaPadrao ?? this.unidadeMedidaPadrao,
      tipoFatorConversao: tipoFatorConversao ?? this.tipoFatorConversao,
      fatorConversao: fatorConversao ?? this.fatorConversao,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      observacao: observacao ?? this.observacao,
    );
  }

  factory ExpedicaoSepararItemUnidadeMedidaConsultaModel.fromJson(
      Map<String, dynamic> json) {
    try {
      return ExpedicaoSepararItemUnidadeMedidaConsultaModel(
        codEmpresa: json['CodEmpresa'],
        codSepararEstoque: json['CodSepararEstoque'],
        item: json['Item'],
        codProduto: json['CodProduto'],
        itemUnidadeMedida: json['ItemUnidadeMedida'],
        codUnidadeMedida: json['CodUnidadeMedida'],
        unidadeMedidaDescricao: json['UnidadeMedidaDescricao'],
        unidadeMedidaPadrao: json['UnidadeMedidaPadrao'] ?? 'S',
        tipoFatorConversao: json['TipoFatorConversao'] ?? 'M',
        fatorConversao: AppHelper.stringToDouble(json['FatorConversao']),
        codigoBarras: json['CodigoBarras'],
        observacao: json['Observacao'],
      );
    } catch (_) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodSepararEstoque': codSepararEstoque,
      'Item': item,
      'CodProduto': codProduto,
      'ItemUnidadeMedida': itemUnidadeMedida,
      'CodUnidadeMedida': codUnidadeMedida,
      'UnidadeMedidaDescricao': unidadeMedidaDescricao,
      'unidadeMedidaPadrao': unidadeMedidaPadrao,
      'TipoFatorConversao': tipoFatorConversao,
      'FatorConversao': fatorConversao,
      'CodigoBarras': codigoBarras,
      'Observacao': observacao,
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaoSepararItemUnidadeMedidaConsultaModel(
        codEmpresa: $codEmpresa, 
        codSepararEstoque: $codSepararEstoque, 
        item: $item, 
        codProduto: $codProduto, 
        itemUnidadeMedida: $itemUnidadeMedida, 
        codUnidadeMedida: $codUnidadeMedida, 
        unidadeMedidaDescricao: $unidadeMedidaDescricao, 
        unidadeMedidaPadrao: $unidadeMedidaPadrao, 
        tipoFatorConversao: $tipoFatorConversao, 
        fatorConversao: $fatorConversao, 
        codigoBarras: $codigoBarras, 
        observacao: $observacao
    )''';
  }
}
