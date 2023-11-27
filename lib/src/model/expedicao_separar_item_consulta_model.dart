import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoSepararItemConsultaModel {
  final int codEmpresa;
  final int codSepararEstoque;
  final String item;
  final String origem;
  final int codOrigem;
  final String? itemOrigem;
  final int codProduto;
  final String nomeProduto;
  final String ativo;
  final String codTipoProduto;
  final String codUnidadeMedida;
  final String nomeUnidadeMedida;
  final int codGrupoProduto;
  final String nomeGrupoProduto;
  final int? codMarca;
  final String? nomeMarca;
  final int? codSetorEstoque;
  final String? nomeSetorEstoque;
  final String? ncm;
  final String? codigoBarras;
  final String? codigoBarras2;
  final String? codigoReferencia;
  final String? codigoFornecedor;
  final String? codigoFabricante;
  final String? codigoOriginal;
  final String? endereco;
  final int codLocaArmazenagem;
  final String nomeLocaArmazenagem;
  final double quantidade;
  final double quantidadeInterna;
  final double quantidadeExterna;
  final double quantidadeSeparacao;

  ExpedicaoSepararItemConsultaModel({
    required this.codEmpresa,
    required this.codSepararEstoque,
    required this.item,
    required this.origem,
    required this.codOrigem,
    this.itemOrigem,
    required this.codProduto,
    required this.nomeProduto,
    required this.ativo,
    required this.codTipoProduto,
    required this.codUnidadeMedida,
    required this.nomeUnidadeMedida,
    required this.codGrupoProduto,
    required this.nomeGrupoProduto,
    this.codMarca,
    this.nomeMarca,
    this.codSetorEstoque,
    this.nomeSetorEstoque,
    this.ncm,
    this.codigoBarras,
    this.codigoBarras2,
    this.codigoReferencia,
    this.codigoFornecedor,
    this.codigoFabricante,
    this.codigoOriginal,
    this.endereco,
    required this.codLocaArmazenagem,
    required this.nomeLocaArmazenagem,
    required this.quantidade,
    required this.quantidadeInterna,
    required this.quantidadeExterna,
    required this.quantidadeSeparacao,
  });

  factory ExpedicaoSepararItemConsultaModel.fromJson(Map<String, dynamic> map) {
    return ExpedicaoSepararItemConsultaModel(
      codEmpresa: map['CodEmpresa'],
      codSepararEstoque: map['CodSepararEstoque'],
      item: map['Item'],
      origem: map['Origem'],
      codOrigem: map['CodOrigem'],
      itemOrigem: map['ItemOrigem'],
      codProduto: map['CodProduto'],
      nomeProduto: map['NomeProduto'],
      ativo: map['Ativo'],
      codTipoProduto: map['CodTipoProduto'],
      codUnidadeMedida: map['CodUnidadeMedida'],
      nomeUnidadeMedida: map['NomeUnidadeMedida'],
      codGrupoProduto: map['CodGrupoProduto'],
      nomeGrupoProduto: map['NomeGrupoProduto'],
      codMarca: map['CodMarca'],
      nomeMarca: map['NomeMarca'],
      codSetorEstoque: map['CodSetorEstoque'],
      nomeSetorEstoque: map['NomeSetorEstoque'],
      ncm: map['NCM'],
      codigoBarras: map['CodigoBarras'],
      codigoBarras2: map['CodigoBarras2'],
      codigoReferencia: map['CodigoReferencia'],
      codigoFornecedor: map['CodigoFornecedor'],
      codigoFabricante: map['CodigoFabricante'],
      codigoOriginal: map['CodigoOriginal'],
      endereco: map['Endereco'],
      codLocaArmazenagem: map['CodLocaArmazenagem'],
      nomeLocaArmazenagem: map['NomeLocaArmazenagem'],
      quantidade: AppHelper.stringToDouble(map['Quantidade']),
      quantidadeInterna: AppHelper.stringToDouble(map['QuantidadeInterna']),
      quantidadeExterna: AppHelper.stringToDouble(map['QuantidadeExterna']),
      quantidadeSeparacao: AppHelper.stringToDouble(map['QuantidadeSeparacao']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodSepararEstoque': codSepararEstoque,
      'Item': item,
      'Origem': origem,
      'CodOrigem': codOrigem,
      'ItemOrigem': itemOrigem,
      'CodProduto': codProduto,
      'NomeProduto': nomeProduto,
      'Ativo': ativo,
      'CodTipoProduto': codTipoProduto,
      'CodUnidadeMedida': codUnidadeMedida,
      'NomeUnidadeMedida': nomeUnidadeMedida,
      'CodGrupoProduto': codGrupoProduto,
      'NomeGrupoProduto': nomeGrupoProduto,
      'CodMarca': codMarca,
      'NomeMarca': nomeMarca,
      'CodSetorEstoque': codSetorEstoque,
      'NomeSetorEstoque': nomeSetorEstoque,
      'NCM': ncm,
      'CodigoBarras': codigoBarras,
      'CodigoBarras2': codigoBarras2,
      'CodigoReferencia': codigoReferencia,
      'CodigoFornecedor': codigoFornecedor,
      'CodigoFabricante': codigoFabricante,
      'CodigoOriginal': codigoOriginal,
      'Endereco': endereco,
      'CodLocaArmazenagem': codLocaArmazenagem,
      'NomeLocaArmazenagem': nomeLocaArmazenagem,
      'Quantidade': quantidade.toStringAsFixed(4),
      'QuantidadeInterna': quantidadeInterna.toStringAsFixed(4),
      'QuantidadeExterna': quantidadeExterna.toStringAsFixed(4),
      'QuantidadeSeparacao': quantidadeSeparacao.toStringAsFixed(4),
    };
  }

  @override
  String toString() {
    return 'ExpedicaoSepararItemConsultaModel(codEmpresa: $codEmpresa, codSepararEstoque: $codSepararEstoque, item: $item, origem: $origem, codOrigem: $codOrigem, itemOrigem: $itemOrigem, codProduto: $codProduto, nomeProduto: $nomeProduto, ativo: $ativo, codTipoProduto: $codTipoProduto, codUnidadeMedida: $codUnidadeMedida, nomeUnidadeMedida: $nomeUnidadeMedida, codGrupoProduto: $codGrupoProduto, nomeGrupoProduto: $nomeGrupoProduto, codMarca: $codMarca, nomeMarca: $nomeMarca, codSetorEstoque: $codSetorEstoque, nomeSetorEstoque: $nomeSetorEstoque, ncm: $ncm, codigoBarras: $codigoBarras, codigoBarras2: $codigoBarras2, codigoReferencia: $codigoReferencia, codigoFornecedor: $codigoFornecedor, codigoFabricante: $codigoFabricante, codigoOriginal: $codigoOriginal, endereco: $endereco, codLocaArmazenagem: $codLocaArmazenagem, nomeLocaArmazenagem: $nomeLocaArmazenagem, quantidade: $quantidade, quantidadeInterna: $quantidadeInterna, quantidadeExterna: $quantidadeExterna, quantidadeSeparacao: $quantidadeSeparacao)';
  }
}
