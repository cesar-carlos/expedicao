import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoConferirItemUnidadeMedidaConsultaModel {
  final int codEmpresa;
  final int codConferir;
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

  ExpedicaoConferirItemUnidadeMedidaConsultaModel({
    required this.codEmpresa,
    required this.codConferir,
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

  ExpedicaoConferirItemUnidadeMedidaConsultaModel copyWith({
    int? codEmpresa,
    int? codConferir,
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
    return ExpedicaoConferirItemUnidadeMedidaConsultaModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codConferir: codConferir ?? this.codConferir,
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

  factory ExpedicaoConferirItemUnidadeMedidaConsultaModel.fromJson(
      Map<String, dynamic> json) {
    try {
      return ExpedicaoConferirItemUnidadeMedidaConsultaModel(
        codEmpresa: json['CodEmpresa'],
        codConferir: json['CodConferir'],
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
      'CodConferir': codConferir,
      'Item': item,
      'CodProduto': codProduto,
      'ItemUnidadeMedida': itemUnidadeMedida,
      'CodUnidadeMedida': codUnidadeMedida,
      'UnidadeMedidaDescricao': unidadeMedidaDescricao,
      'UnidadeMedidaPadrao': unidadeMedidaPadrao,
      'TipoFatorConversao': tipoFatorConversao,
      'FatorConversao': fatorConversao,
      'CodigoBarras': codigoBarras,
      'Observacao': observacao,
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaoConferirItemUnidadeMedidaConsultaModel(
        codEmpresa: $codEmpresa, 
        codConferir: $codConferir, 
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
