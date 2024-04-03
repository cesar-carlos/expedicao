import 'package:app_expedicao/src/app/app_helper.dart';

class EstoqueProdutoConversaoUnidadeConsultaModel {
  final int codProduto;
  final String nomeProduto;
  final String item;
  final String codUnidadeMedida;
  final String unidadeMedidaDescricao;
  final String unidadeMedidaPadrao;
  final String tipoFatorConversao;
  final double fatorConversao;
  final String? codigoBarras;
  final double? precoVenda;
  final double? precoVenda2;
  final double? precoVenda3;
  final double? precoVenda4;
  final double? precoVenda5;
  final String? observacao;

  EstoqueProdutoConversaoUnidadeConsultaModel({
    required this.codProduto,
    required this.nomeProduto,
    required this.item,
    required this.codUnidadeMedida,
    required this.unidadeMedidaDescricao,
    required this.unidadeMedidaPadrao,
    required this.tipoFatorConversao,
    required this.fatorConversao,
    this.codigoBarras,
    this.precoVenda = 0.00,
    this.precoVenda2 = 0.00,
    this.precoVenda3 = 0.00,
    this.precoVenda4 = 0.00,
    this.precoVenda5 = 0.00,
    this.observacao,
  });

  EstoqueProdutoConversaoUnidadeConsultaModel copyWith({
    int? codProduto,
    String? nomeProduto,
    String? item,
    String? codUnidadeMedida,
    String? unidadeMedidaDescricao,
    String? unidadeMedidaPadrao,
    String? tipoFatorConversao,
    double? fatorConversao,
    String? codigoBarras,
    double? precoVenda,
    double? precoVenda2,
    double? precoVenda3,
    double? precoVenda4,
    double? precoVenda5,
    String? observacao,
  }) {
    return EstoqueProdutoConversaoUnidadeConsultaModel(
      codProduto: codProduto ?? this.codProduto,
      nomeProduto: nomeProduto ?? this.nomeProduto,
      item: item ?? this.item,
      codUnidadeMedida: codUnidadeMedida ?? this.codUnidadeMedida,
      unidadeMedidaDescricao:
          unidadeMedidaDescricao ?? this.unidadeMedidaDescricao,
      unidadeMedidaPadrao: unidadeMedidaPadrao ?? this.unidadeMedidaPadrao,
      tipoFatorConversao: tipoFatorConversao ?? this.tipoFatorConversao,
      fatorConversao: fatorConversao ?? this.fatorConversao,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      precoVenda: precoVenda ?? this.precoVenda,
      precoVenda2: precoVenda2 ?? this.precoVenda2,
      precoVenda3: precoVenda3 ?? this.precoVenda3,
      precoVenda4: precoVenda4 ?? this.precoVenda4,
      precoVenda5: precoVenda5 ?? this.precoVenda5,
      observacao: observacao ?? this.observacao,
    );
  }

  factory EstoqueProdutoConversaoUnidadeConsultaModel.fromJson(
      Map<String, dynamic> json) {
    try {
      return EstoqueProdutoConversaoUnidadeConsultaModel(
        codProduto: json['CodProduto'],
        nomeProduto: json['NomeProduto'],
        item: json['Item'],
        codUnidadeMedida: json['CodUnidadeMedida'],
        unidadeMedidaDescricao: json['UnidadeMedidaDescricao'],
        unidadeMedidaPadrao: json['UnidadeMedidaPadrao'],
        tipoFatorConversao: json['TipoFatorConversao'] ?? 'M',
        fatorConversao: AppHelper.stringToDouble(json['FatorConversao']),
        codigoBarras: json['CodigoBarras'],
        precoVenda: AppHelper.stringToDouble(json['PrecoVenda']),
        precoVenda2: AppHelper.stringToDouble(json['PrecoVenda2']),
        precoVenda3: AppHelper.stringToDouble(json['PrecoVenda3']),
        precoVenda4: AppHelper.stringToDouble(json['PrecoVenda4']),
        precoVenda5: AppHelper.stringToDouble(json['PrecoVenda5']),
        observacao: json['Observacao'],
      );
    } catch (_) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'CodProduto': codProduto,
      'NomeProduto': nomeProduto,
      'Item': item,
      'CodUnidadeMedida': codUnidadeMedida,
      'UnidadeMedidaDescricao': unidadeMedidaDescricao,
      'UnidadeMedidaPadrao': unidadeMedidaPadrao,
      'TipoFatorConversao': tipoFatorConversao,
      'FatorConversao': fatorConversao,
      'CodigoBarras': codigoBarras,
      'PrecoVenda': precoVenda,
      'PrecoVenda2': precoVenda2,
      'PrecoVenda3': precoVenda3,
      'PrecoVenda4': precoVenda4,
      'PrecoVenda5': precoVenda5,
      'Observacao': observacao,
    };
  }

  @override
  String toString() {
    return '''
      EstoqueProdutoConversaoUnidadeConsultaModel(
        codProduto: $codProduto, 
        nomeProduto: $nomeProduto, 
        item: $item, 
        codUnidadeMedida: $codUnidadeMedida, 
        unidadeMedidaDescricao: $unidadeMedidaDescricao, 
        unidadeMedidaPadrao: $unidadeMedidaPadrao, 
        tipoFatorConversao: $tipoFatorConversao, 
        fatorConversao: $fatorConversao, 
        codigoBarras: $codigoBarras, 
        precoVenda: $precoVenda, 
        precoVenda2: $precoVenda2, 
        precoVenda3: $precoVenda3, 
        precoVenda4: $precoVenda4, 
        precoVenda5: $precoVenda5, 
        observacao: $observacao
    )''';
  }
}
