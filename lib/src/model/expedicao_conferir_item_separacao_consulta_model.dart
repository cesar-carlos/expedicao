import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoConferirItemSeparacaoConsultaModel {
  final int codEmpresa;
  final int codSepararEstoque;
  final int codCarrinhoPercurso;
  final String itemCarrinhoPercurso;
  final String situacao;
  final String origem;
  final int codOrigem;
  final int codPrioridade;
  final String nomePrioridade;
  final int codCarrinho;
  final String nomeCarrinho;
  final String codigoBarrasCarrinho;
  final String situacaoCarrinho;
  final int codProduto;
  final String nomeProduto;
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
  final String? enderecoDescricao;
  final double quantidadeSeparacao;

  ExpedicaoConferirItemSeparacaoConsultaModel({
    required this.codEmpresa,
    required this.codSepararEstoque,
    required this.codCarrinhoPercurso,
    required this.itemCarrinhoPercurso,
    required this.situacao,
    required this.origem,
    required this.codOrigem,
    required this.codPrioridade,
    required this.nomePrioridade,
    required this.codCarrinho,
    required this.nomeCarrinho,
    required this.codigoBarrasCarrinho,
    required this.situacaoCarrinho,
    required this.codProduto,
    required this.nomeProduto,
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
    this.enderecoDescricao,
    required this.quantidadeSeparacao,
  });

  ExpedicaoConferirItemSeparacaoConsultaModel copyWith({
    int? codEmpresa,
    int? codSepararEstoque,
    int? codCarrinhoPercurso,
    String? itemCarrinhoPercurso,
    String? situacao,
    String? origem,
    int? codOrigem,
    int? codPrioridade,
    String? nomePrioridade,
    int? codCarrinho,
    String? nomeCarrinho,
    String? codigoBarrasCarrinho,
    String? situacaoCarrinho,
    int? codProduto,
    String? nomeProduto,
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
    String? enderecoDescricao,
    double? quantidadeSeparacao,
  }) {
    return ExpedicaoConferirItemSeparacaoConsultaModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codSepararEstoque: codSepararEstoque ?? this.codSepararEstoque,
      codCarrinhoPercurso: codCarrinhoPercurso ?? this.codCarrinhoPercurso,
      itemCarrinhoPercurso: itemCarrinhoPercurso ?? this.itemCarrinhoPercurso,
      situacao: situacao ?? this.situacao,
      origem: origem ?? this.origem,
      codOrigem: codOrigem ?? this.codOrigem,
      codPrioridade: codPrioridade ?? this.codPrioridade,
      nomePrioridade: nomePrioridade ?? this.nomePrioridade,
      codCarrinho: codCarrinho ?? this.codCarrinho,
      nomeCarrinho: nomeCarrinho ?? this.nomeCarrinho,
      codigoBarrasCarrinho: codigoBarrasCarrinho ?? this.codigoBarrasCarrinho,
      situacaoCarrinho: situacaoCarrinho ?? this.situacaoCarrinho,
      codProduto: codProduto ?? this.codProduto,
      nomeProduto: nomeProduto ?? this.nomeProduto,
      codUnidadeMedida: codUnidadeMedida ?? this.codUnidadeMedida,
      nomeUnidadeMedida: nomeUnidadeMedida ?? this.nomeUnidadeMedida,
      codGrupoProduto: codGrupoProduto ?? this.codGrupoProduto,
      nomeGrupoProduto: nomeGrupoProduto ?? this.nomeGrupoProduto,
      codMarca: codMarca ?? this.codMarca,
      nomeMarca: nomeMarca ?? this.nomeMarca,
      nomeSetorEstoque: nomeSetorEstoque ?? this.nomeSetorEstoque,
      ncm: ncm ?? this.ncm,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      codigoBarras2: codigoBarras2 ?? this.codigoBarras2,
      codigoReferencia: codigoReferencia ?? this.codigoReferencia,
      codigoFornecedor: codigoFornecedor ?? this.codigoFornecedor,
      codigoFabricante: codigoFabricante ?? this.codigoFabricante,
      codigoOriginal: codigoOriginal ?? this.codigoOriginal,
      endereco: endereco ?? this.endereco,
      enderecoDescricao: enderecoDescricao ?? this.enderecoDescricao,
      codSetorEstoque: codSetorEstoque ?? this.codSetorEstoque,
      quantidadeSeparacao: quantidadeSeparacao ?? this.quantidadeSeparacao,
    );
  }

  factory ExpedicaoConferirItemSeparacaoConsultaModel.fromJson(
      Map<String, dynamic> map) {
    return ExpedicaoConferirItemSeparacaoConsultaModel(
      codEmpresa: map['CodEmpresa'],
      codSepararEstoque: map['CodSepararEstoque'],
      codCarrinhoPercurso: map['CodCarrinhoPercurso'],
      itemCarrinhoPercurso: map['ItemCarrinhoPercurso'],
      situacao: map['Situacao'],
      origem: map['Origem'],
      codOrigem: map['CodOrigem'],
      codPrioridade: map['CodPrioridade'],
      nomePrioridade: map['NomePrioridade'],
      codCarrinho: map['CodCarrinho'],
      nomeCarrinho: map['NomeCarrinho'],
      codigoBarrasCarrinho: map['CodigoBarrasCarrinho'],
      situacaoCarrinho: map['SituacaoCarrinho'],
      codProduto: map['CodProduto'],
      nomeProduto: map['NomeProduto'],
      codUnidadeMedida: map['CodUnidadeMedida'],
      nomeUnidadeMedida: map['NomeUnidadeMedida'],
      codGrupoProduto: map['CodGrupoProduto'],
      nomeGrupoProduto: map['NomeGrupoProduto'],
      codMarca: map['CodMarca'],
      nomeMarca: map['NomeMarca'],
      codSetorEstoque: map['CodSetorEstoque'],
      nomeSetorEstoque: map['NomeSetorEstoque'],
      ncm: map['NCM'] ?? '00000000',
      codigoBarras: map['CodigoBarras'],
      codigoBarras2: map['CodigoBarras2'],
      codigoReferencia: map['CodigoReferencia'],
      codigoFornecedor: map['CodigoFornecedor'],
      codigoFabricante: map['CodigoFabricante'],
      codigoOriginal: map['CodigoOriginal'],
      endereco: map['Endereco'],
      enderecoDescricao: map['EnderecoDescricao'],
      quantidadeSeparacao: AppHelper.stringToDouble(map['QuantidadeSeparacao']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodSepararEstoque': codSepararEstoque,
      'CodCarrinhoPercurso': codCarrinhoPercurso,
      'ItemCarrinhoPercurso': itemCarrinhoPercurso,
      'Situacao': situacao,
      'Origem': origem,
      'CodOrigem': codOrigem,
      'CodPrioridade': codPrioridade,
      'NomePrioridade': nomePrioridade,
      'CodCarrinho': codCarrinho,
      'NomeCarrinho': nomeCarrinho,
      'CodigoBarrasCarrinho': codigoBarrasCarrinho,
      'SituacaoCarrinho': situacaoCarrinho,
      'CodProduto': codProduto,
      'NomeProduto': nomeProduto,
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
      'EnderecoDescricao': enderecoDescricao,
      'QuantidadeSeparacao': quantidadeSeparacao.toStringAsFixed(4),
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaoConferirItemSeparacaoConsultaModel(
        codEmpresa: $codEmpresa, 
        codSepararEstoque: $codSepararEstoque, 
        codCarrinhoPercurso: $codCarrinhoPercurso, 
        itemCarrinhoPercurso: $itemCarrinhoPercurso, 
        situacao: $situacao, 
        origem: $origem, 
        codOrigem: $codOrigem, 
        codPrioridade: $codPrioridade, 
        nomePrioridade: $nomePrioridade, 
        codCarrinho: $codCarrinho, 
        nomeCarrinho: $nomeCarrinho, 
        codigoBarrasCarrinho: $codigoBarrasCarrinho, 
        situacaoCarrinho: $situacaoCarrinho, 
        codProduto: $codProduto, 
        nomeProduto: $nomeProduto, 
        codUnidadeMedida: $codUnidadeMedida, 
        nomeUnidadeMedida: $nomeUnidadeMedida, 
        codGrupoProduto: $codGrupoProduto, 
        nomeGrupoProduto: $nomeGrupoProduto, 
        codMarca: $codMarca, 
        nomeMarca: $nomeMarca, 
        codSetorEstoque: $codSetorEstoque, 
        nomeSetorEstoque: $nomeSetorEstoque, 
        ncm: $ncm, 
        codigoBarras: $codigoBarras, 
        codigoBarras2: $codigoBarras2, 
        codigoReferencia: $codigoReferencia, 
        codigoFornecedor: $codigoFornecedor, 
        codigoFabricante: $codigoFabricante, 
        codigoOriginal: $codigoOriginal, 
        endereco: $endereco, 
        enderecoDescricao: $enderecoDescricao, 
        quantidadeSeparacao: $quantidadeSeparacao
    )''';
  }
}
