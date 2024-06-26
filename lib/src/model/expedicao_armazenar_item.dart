import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoArmazenarItem {
  int codEmpresa;
  int codArmazenar;
  String item;
  String situacao;
  int? codcarrinhoPercurso;
  String? itemcarrinhoPercurso;
  int codLocalArmazenagem;
  int codProduto;
  String nomeProduto;
  String codUnidadeMedida;
  String? codProdutoEndereco;
  String? codigoBarras;
  double quantidade;

  ExpedicaoArmazenarItem({
    required this.codEmpresa,
    required this.codArmazenar,
    required this.item,
    required this.situacao,
    this.codcarrinhoPercurso,
    this.itemcarrinhoPercurso,
    required this.codLocalArmazenagem,
    required this.codProduto,
    required this.nomeProduto,
    required this.codUnidadeMedida,
    this.codProdutoEndereco,
    this.codigoBarras,
    required this.quantidade,
  });

  ExpedicaoArmazenarItem copyWith({
    int? codEmpresa,
    int? codArmazenar,
    String? item,
    String? situacao,
    int? codcarrinhoPercurso,
    String? itemcarrinhoPercurso,
    int? codLocalArmazenagem,
    int? codProduto,
    String? nomeProduto,
    String? codUnidadeMedida,
    String? codProdutoEndereco,
    String? codigoBarras,
    double? quantidade,
  }) {
    return ExpedicaoArmazenarItem(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codArmazenar: codArmazenar ?? this.codArmazenar,
      item: item ?? this.item,
      situacao: situacao ?? this.situacao,
      codcarrinhoPercurso: codcarrinhoPercurso ?? this.codcarrinhoPercurso,
      itemcarrinhoPercurso: itemcarrinhoPercurso ?? this.itemcarrinhoPercurso,
      codLocalArmazenagem: codLocalArmazenagem ?? this.codLocalArmazenagem,
      codProduto: codProduto ?? this.codProduto,
      nomeProduto: nomeProduto ?? this.nomeProduto,
      codUnidadeMedida: codUnidadeMedida ?? this.codUnidadeMedida,
      codProdutoEndereco: codProdutoEndereco ?? this.codProdutoEndereco,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      quantidade: quantidade ?? this.quantidade,
    );
  }

  factory ExpedicaoArmazenarItem.fromJson(Map<String, dynamic> json) {
    try {
      return ExpedicaoArmazenarItem(
        codEmpresa: json['CodEmpresa'],
        codArmazenar: json['CodArmazenar'],
        item: json['Item'],
        situacao: json['Situacao'],
        codcarrinhoPercurso: json['CodcarrinhoPercurso'],
        itemcarrinhoPercurso: json['ItemcarrinhoPercurso'],
        codLocalArmazenagem: json['CodLocalArmazenagem'],
        codProduto: json['CodProduto'],
        nomeProduto: json['NomeProduto'],
        codUnidadeMedida: json['CodUnidadeMedida'],
        codProdutoEndereco: json['CodProdutoEndereco'],
        codigoBarras: json['CodigoBarras'],
        quantidade: AppHelper.stringToDouble(json['Quantidade']),
      );
    } catch (_) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodArmazenar': codArmazenar,
      'Item': item,
      'Situacao': situacao,
      'CodCarrinhoPercurso': codcarrinhoPercurso,
      'ItemCarrinhoPercurso': itemcarrinhoPercurso,
      'CodLocalArmazenagem': codLocalArmazenagem,
      'CodProduto': codProduto,
      'NomeProduto': nomeProduto,
      'CodUnidadeMedida': codUnidadeMedida,
      'CodProdutoEndereco': codProdutoEndereco,
      'CodigoBarras': codigoBarras,
      'Quantidade': quantidade.toStringAsFixed(4),
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaoArmazenarItem(
        codEmpresa: $codEmpresa, 
        codArmazenar: $codArmazenar, 
        item: $item, 
        situacao: $situacao,
        codcarrinhoPercurso: $codcarrinhoPercurso,
        itemcarrinhoPercurso: $itemcarrinhoPercurso,
        codLocalArmazenagem: $codLocalArmazenagem,
        codProduto: $codProduto, 
        nomeProduto: $nomeProduto, 
        codUnidadeMedida: $codUnidadeMedida, 
        codProdutoEndereco: $codProdutoEndereco, 
        codigoBarras: $codigoBarras, 
        quantidade: $quantidade,
    )''';
  }
}
