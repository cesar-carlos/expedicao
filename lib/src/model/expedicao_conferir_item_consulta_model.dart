import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoConferirItemConsultaModel {
  final int codEmpresa;
  final int codConferir;
  final String item;
  final String origem;
  final int codOrigem;
  final int codCarrinhoPercurso;
  final String itemCarrinhoPercurso;
  final int codCarrinho;
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
  final double quantidade;
  final double quantidadeConferida;

  ExpedicaoConferirItemConsultaModel({
    required this.codEmpresa,
    required this.codConferir,
    required this.item,
    required this.origem,
    required this.codOrigem,
    required this.codCarrinhoPercurso,
    required this.itemCarrinhoPercurso,
    required this.codCarrinho,
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
    required this.quantidade,
    required this.quantidadeConferida,
  });

  ExpedicaoConferirItemConsultaModel copyWith({
    int? codEmpresa,
    int? codConferir,
    String? item,
    String? origem,
    int? codOrigem,
    int? codCarrinhoPercurso,
    String? itemCarrinhoPercurso,
    int? codCarrinho,
    int? codProduto,
    String? nomeProduto,
    String? ativo,
    String? codTipoProduto,
    String? codUnidadeMedida,
    String? nomeUnidadeMedida,
    int? codGrupoProduto,
    String? nomeGrupoProduto,
    int? codMarca,
    String? nomeMarca,
    int? codSetorEstoque,
    String? nomeSetorEstoque,
    String? ncm,
    String? codigoBarras,
    String? codigoBarras2,
    String? codigoReferencia,
    String? codigoFornecedor,
    String? codigoFabricante,
    String? codigoOriginal,
    String? endereco,
    double? quantidade,
    double? quantidadeConferida,
  }) {
    return ExpedicaoConferirItemConsultaModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codConferir: codConferir ?? this.codConferir,
      item: item ?? this.item,
      origem: origem ?? this.origem,
      codOrigem: codOrigem ?? this.codOrigem,
      codCarrinhoPercurso: codCarrinhoPercurso ?? this.codCarrinhoPercurso,
      itemCarrinhoPercurso: itemCarrinhoPercurso ?? this.itemCarrinhoPercurso,
      codCarrinho: codCarrinho ?? this.codCarrinho,
      codProduto: codProduto ?? this.codProduto,
      nomeProduto: nomeProduto ?? this.nomeProduto,
      ativo: ativo ?? this.ativo,
      codTipoProduto: codTipoProduto ?? this.codTipoProduto,
      codUnidadeMedida: codUnidadeMedida ?? this.codUnidadeMedida,
      nomeUnidadeMedida: nomeUnidadeMedida ?? this.nomeUnidadeMedida,
      codGrupoProduto: codGrupoProduto ?? this.codGrupoProduto,
      nomeGrupoProduto: nomeGrupoProduto ?? this.nomeGrupoProduto,
      codMarca: codMarca ?? this.codMarca,
      nomeMarca: nomeMarca ?? this.nomeMarca,
      codSetorEstoque: codSetorEstoque ?? this.codSetorEstoque,
      nomeSetorEstoque: nomeSetorEstoque ?? this.nomeSetorEstoque,
      ncm: ncm ?? this.ncm,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      codigoBarras2: codigoBarras2 ?? this.codigoBarras2,
      codigoReferencia: codigoReferencia ?? this.codigoReferencia,
      codigoFornecedor: codigoFornecedor ?? this.codigoFornecedor,
      codigoFabricante: codigoFabricante ?? this.codigoFabricante,
      codigoOriginal: codigoOriginal ?? this.codigoOriginal,
      endereco: endereco ?? this.endereco,
      quantidade: quantidade ?? this.quantidade,
      quantidadeConferida: quantidadeConferida ?? this.quantidadeConferida,
    );
  }

  factory ExpedicaoConferirItemConsultaModel.fromJson(Map map) {
    return ExpedicaoConferirItemConsultaModel(
      codEmpresa: map['CodEmpresa'],
      codConferir: map['CodConferir'],
      item: map['Item'],
      origem: map['Origem'],
      codOrigem: map['CodOrigem'],
      codCarrinhoPercurso: map['CodCarrinhoPercurso'],
      itemCarrinhoPercurso: map['ItemCarrinhoPercurso'],
      codCarrinho: map['CodCarrinho'],
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
      quantidade: AppHelper.stringToDouble(map['Quantidade']),
      quantidadeConferida: AppHelper.stringToDouble(map['QuantidadeConferida']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodConferir': codConferir,
      'Item': item,
      'Origem': origem,
      'CodOrigem': codOrigem,
      'CodCarrinhoPercurso': codCarrinhoPercurso,
      'ItemCarrinhoPercurso': itemCarrinhoPercurso,
      'CodCarrinho': codCarrinho,
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
      'Quantidade': quantidade.toStringAsFixed(4),
      'QuantidadeConferida': quantidadeConferida.toStringAsFixed(4),
    };
  }

  @override
  String toString() {
    return 'ExpedicaoConferirItemConsultaModel(codEmpresa: $codEmpresa, codConferir: $codConferir, item: $item, origem: $origem, codOrigem: $codOrigem, codCarrinhoPercurso: $codCarrinhoPercurso, itemCarrinhoPercurso: $itemCarrinhoPercurso, codCarrinho: $codCarrinho, codProduto: $codProduto, nomeProduto: $nomeProduto, ativo: $ativo, codTipoProduto: $codTipoProduto, codUnidadeMedida: $codUnidadeMedida, nomeUnidadeMedida: $nomeUnidadeMedida, codGrupoProduto: $codGrupoProduto, nomeGrupoProduto: $nomeGrupoProduto, codMarca: $codMarca, nomeMarca: $nomeMarca, codSetorEstoque: $codSetorEstoque, nomeSetorEstoque: $nomeSetorEstoque, ncm: $ncm, codigoBarras: $codigoBarras, codigoBarras2: $codigoBarras2, codigoReferencia: $codigoReferencia, codigoFornecedor: $codigoFornecedor, codigoFabricante: $codigoFabricante, codigoOriginal: $codigoOriginal, endereco: $endereco, quantidade: $quantidade, quantidadeConferida: $quantidadeConferida)';
  }
}
