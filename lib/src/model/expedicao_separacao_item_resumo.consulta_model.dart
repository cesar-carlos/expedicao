import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaSeparacaoItemResumoConsultaModel {
  final int codEmpresa;
  final int codSepararEstoque;
  final String origem;
  final int codOrigem;
  final String situacao;
  final int codCarrinhoPercurso;
  final String itemCarrinhoPercurso;
  final int codCarrinho;
  final String descricaoCarrinho;
  final int codLocalArmazenagem;
  final int codProduto;
  final String nomeProduto;
  final String codUnidadeMedida;
  final String descricaoUnidadeMedida;
  final String? codigoBarras;
  final String? codProdutoEndereco;
  final String? descricaoProdutoEndereco;
  final double quantidade;

  ExpedicaSeparacaoItemResumoConsultaModel({
    required this.codEmpresa,
    required this.codSepararEstoque,
    required this.origem,
    required this.codOrigem,
    required this.situacao,
    required this.codCarrinhoPercurso,
    required this.itemCarrinhoPercurso,
    required this.codCarrinho,
    required this.descricaoCarrinho,
    required this.codLocalArmazenagem,
    required this.codProduto,
    required this.nomeProduto,
    required this.codUnidadeMedida,
    required this.descricaoUnidadeMedida,
    this.codigoBarras,
    this.codProdutoEndereco,
    this.descricaoProdutoEndereco,
    required this.quantidade,
  });

  ExpedicaSeparacaoItemResumoConsultaModel copyWith({
    int? codEmpresa,
    int? codSepararEstoque,
    String? origem,
    int? codOrigem,
    String? situacao,
    int? codCarrinhoPercurso,
    String? itemCarrinhoPercurso,
    int? codCarrinho,
    String? descricaoCarrinho,
    int? codLocalArmazenagem,
    int? codProduto,
    String? nomeProduto,
    String? codUnidadeMedida,
    String? descricaoUnidadeMedida,
    String? codigoBarras,
    String? codProdutoEndereco,
    String? descricaoProdutoEndereco,
    double? quantidade,
  }) {
    return ExpedicaSeparacaoItemResumoConsultaModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codSepararEstoque: codSepararEstoque ?? this.codSepararEstoque,
      origem: origem ?? this.origem,
      codOrigem: codOrigem ?? this.codOrigem,
      situacao: situacao ?? this.situacao,
      codCarrinhoPercurso: codCarrinhoPercurso ?? this.codCarrinhoPercurso,
      itemCarrinhoPercurso: itemCarrinhoPercurso ?? this.itemCarrinhoPercurso,
      codCarrinho: codCarrinho ?? this.codCarrinho,
      descricaoCarrinho: descricaoCarrinho ?? this.descricaoCarrinho,
      codLocalArmazenagem: codLocalArmazenagem ?? this.codLocalArmazenagem,
      codProduto: codProduto ?? this.codProduto,
      nomeProduto: nomeProduto ?? this.nomeProduto,
      codUnidadeMedida: codUnidadeMedida ?? this.codUnidadeMedida,
      descricaoUnidadeMedida:
          descricaoUnidadeMedida ?? this.descricaoUnidadeMedida,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      codProdutoEndereco: codProdutoEndereco ?? this.codProdutoEndereco,
      descricaoProdutoEndereco:
          descricaoProdutoEndereco ?? this.descricaoProdutoEndereco,
      quantidade: quantidade ?? this.quantidade,
    );
  }

  factory ExpedicaSeparacaoItemResumoConsultaModel.fromJson(
      Map<String, dynamic> json) {
    try {
      return ExpedicaSeparacaoItemResumoConsultaModel(
        codEmpresa: json['CodEmpresa'],
        codSepararEstoque: json['CodSepararEstoque'],
        origem: json['Origem'],
        codOrigem: json['CodOrigem'],
        situacao: json['Situacao'],
        codCarrinhoPercurso: json['CodCarrinhoPercurso'],
        itemCarrinhoPercurso: json['ItemCarrinhoPercurso'],
        codCarrinho: json['CodCarrinho'],
        descricaoCarrinho: json['DescricaoCarrinho'],
        codLocalArmazenagem: json['CodLocalArmazenagem'],
        codProduto: json['CodProduto'],
        nomeProduto: json['NomeProduto'],
        codUnidadeMedida: json['CodUnidadeMedida'],
        descricaoUnidadeMedida: json['DescricaoUnidadeMedida'],
        codigoBarras: json['CodigoBarras'],
        codProdutoEndereco: json['CodProdutoEndereco'],
        descricaoProdutoEndereco: json['DescricaoProdutoEndereco'],
        quantidade: AppHelper.stringToDouble(json['Quantidade']),
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodSepararEstoque': codSepararEstoque,
      'Origem': origem,
      'CodOrigem': codOrigem,
      'Situacao': situacao,
      'CodCarrinhoPercurso': codCarrinhoPercurso,
      'ItemCarrinhoPercurso': itemCarrinhoPercurso,
      'CodCarrinho': codCarrinho,
      'DescricaoCarrinho': descricaoCarrinho,
      'CodLocalArmazenagem': codLocalArmazenagem,
      'CodProduto': codProduto,
      'NomeProduto': nomeProduto,
      'CodUnidadeMedida': codUnidadeMedida,
      'DescricaoUnidadeMedida': descricaoUnidadeMedida,
      'CodigoBarras': codigoBarras,
      'CodProdutoEndereco': codProdutoEndereco,
      'DescricaoProdutoEndereco': descricaoProdutoEndereco,
      'Quantidade': quantidade,
    };
  }
}
