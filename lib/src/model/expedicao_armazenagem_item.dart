import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoArmazenagemItem {
  int codEmpresa;
  int codArmazenagem;
  String item;
  int codCarrinhoPercurso;
  String itemCarrinhoPercurso;
  int codLocalArmazenagem;
  int? codSetorEstoque;
  int codProduto;
  String nomeProduto;
  String codUnidadeMedida;
  String? codigoBarras;
  String codProdutoEndereco;
  double quantidade;
  double quantidadeArmazenada;

  ExpedicaoArmazenagemItem({
    required this.codEmpresa,
    required this.codArmazenagem,
    required this.item,
    required this.codCarrinhoPercurso,
    required this.itemCarrinhoPercurso,
    required this.codLocalArmazenagem,
    this.codSetorEstoque,
    required this.codProduto,
    required this.nomeProduto,
    required this.codUnidadeMedida,
    this.codigoBarras,
    required this.codProdutoEndereco,
    required this.quantidade,
    required this.quantidadeArmazenada,
  });

  ExpedicaoArmazenagemItem copyWith({
    int? codEmpresa,
    int? codArmazenagem,
    String? item,
    int? codCarrinhoPercurso,
    String? ItemCarrinhoPercurso,
    int? codLocalArmazenagem,
    int? codSetorEstoque,
    int? codProduto,
    String? nomeProduto,
    String? codUnidadeMedida,
    String? codigoBarras,
    String? codProdutoEndereco,
    double? quantidade,
    double? quantidadeArmazenada,
  }) {
    return ExpedicaoArmazenagemItem(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codArmazenagem: codArmazenagem ?? this.codArmazenagem,
      item: item ?? this.item,
      codCarrinhoPercurso: codCarrinhoPercurso ?? this.codCarrinhoPercurso,
      itemCarrinhoPercurso: ItemCarrinhoPercurso ?? this.itemCarrinhoPercurso,
      codLocalArmazenagem: codLocalArmazenagem ?? this.codLocalArmazenagem,
      codSetorEstoque: codSetorEstoque ?? this.codSetorEstoque,
      codProduto: codProduto ?? this.codProduto,
      nomeProduto: nomeProduto ?? this.nomeProduto,
      codUnidadeMedida: codUnidadeMedida ?? this.codUnidadeMedida,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      codProdutoEndereco: codProdutoEndereco ?? this.codProdutoEndereco,
      quantidade: quantidade ?? this.quantidade,
      quantidadeArmazenada: quantidadeArmazenada ?? this.quantidadeArmazenada,
    );
  }

  factory ExpedicaoArmazenagemItem.fromJson(Map<String, dynamic> json) {
    try {
      return ExpedicaoArmazenagemItem(
        codEmpresa: json['CodEmpresa'],
        codArmazenagem: json['CodArmazenagem'],
        item: json['Item'],
        codCarrinhoPercurso: json['CodCarrinhoPercurso'],
        itemCarrinhoPercurso: json['ItemCarrinhoPercurso'],
        codLocalArmazenagem: json['CodLocalArmazenagem'],
        codSetorEstoque: json['CodSetorEstoque'],
        codProduto: json['CodProduto'],
        nomeProduto: json['NomeProduto'],
        codUnidadeMedida: json['CodUnidadeMedida'],
        codigoBarras: json['CodigoBarras'],
        codProdutoEndereco: json['CodProdutoEndereco'],
        quantidade: AppHelper.stringToDouble(json['Quantidade']),
        quantidadeArmazenada:
            AppHelper.stringToDouble(json['QuantidadeArmazenada']),
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodArmazenagem': codArmazenagem,
      'Item': item,
      'CodCarrinhoPercurso': codCarrinhoPercurso,
      'ItemCarrinhoPercurso': itemCarrinhoPercurso,
      'CodLocalArmazenagem': codLocalArmazenagem,
      'CodSetorEstoque': codSetorEstoque,
      'CodProduto': codProduto,
      'NomeProduto': nomeProduto,
      'CodUnidadeMedida': codUnidadeMedida,
      'CodigoBarras': codigoBarras,
      'CodProdutoEndereco': codProdutoEndereco,
      'Quantidade': quantidade.toStringAsFixed(4),
      'QuantidadeArmazenada': quantidadeArmazenada.toStringAsFixed(4),
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaoArmazenagemItem(
        codEmpresa: $codEmpresa, 
        codArmazenagem: $codArmazenagem, 
        item: $item, 
        codCarrinhoPercurso: $codCarrinhoPercurso, 
        itemCarrinhoPercurso: $itemCarrinhoPercurso, 
        codLocalArmazenagem: $codLocalArmazenagem, 
        codSetorEstoque: $codSetorEstoque, 
        codProduto: $codProduto, 
        nomeProduto: $nomeProduto, 
        codUnidadeMedida: $codUnidadeMedida, 
        codigoBarras: $codigoBarras, 
        codProdutoEndereco: $codProdutoEndereco, 
        quantidade: $quantidade, 
        quantidadeArmazenada: $quantidadeArmazenada
    )''';
  }
}
