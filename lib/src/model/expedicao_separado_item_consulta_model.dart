import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoSeparadoItemConsultaModel {
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
  final int codLocalArmazenagem;
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
  final String? codigoBarras;
  final String? codigoBarras2;
  final String? codigoReferencia;
  final String? codigoFornecedor;
  final String? codigoFabricante;
  final String? codigoOriginal;
  final String? endereco;
  final String? enderecoDescricao;
  final double quantidadeSeparacao;
  final String? historico;
  final String? observacao;

  ExpedicaoSeparadoItemConsultaModel({
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
    required this.codLocalArmazenagem,
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
    this.codigoBarras,
    this.codigoBarras2,
    this.codigoReferencia,
    this.codigoFornecedor,
    this.codigoFabricante,
    this.codigoOriginal,
    this.endereco,
    this.enderecoDescricao,
    required this.quantidadeSeparacao,
    this.historico,
    this.observacao,
  });

  ExpedicaoSeparadoItemConsultaModel copyWith({
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
    int? codLocalArmazenagem,
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
    String? historico,
    String? observacao,
  }) {
    return ExpedicaoSeparadoItemConsultaModel(
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
      codLocalArmazenagem: codLocalArmazenagem ?? this.codLocalArmazenagem,
      codProduto: codProduto ?? this.codProduto,
      nomeProduto: nomeProduto ?? this.nomeProduto,
      codUnidadeMedida: codUnidadeMedida ?? this.codUnidadeMedida,
      nomeUnidadeMedida: nomeUnidadeMedida ?? this.nomeUnidadeMedida,
      codGrupoProduto: codGrupoProduto ?? this.codGrupoProduto,
      nomeGrupoProduto: nomeGrupoProduto ?? this.nomeGrupoProduto,
      codMarca: codMarca ?? this.codMarca,
      nomeMarca: nomeMarca ?? this.nomeMarca,
      nomeSetorEstoque: nomeSetorEstoque ?? this.nomeSetorEstoque,
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
      historico: historico ?? this.historico,
      observacao: observacao ?? this.observacao,
    );
  }

  factory ExpedicaoSeparadoItemConsultaModel.fromJson(
      Map<String, dynamic> json) {
    try {
      return ExpedicaoSeparadoItemConsultaModel(
        codEmpresa: json['CodEmpresa'],
        codSepararEstoque: json['CodSepararEstoque'],
        codCarrinhoPercurso: json['CodCarrinhoPercurso'],
        itemCarrinhoPercurso: json['ItemCarrinhoPercurso'],
        situacao: json['Situacao'],
        origem: json['Origem'],
        codOrigem: json['CodOrigem'],
        codPrioridade: json['CodPrioridade'],
        nomePrioridade: json['NomePrioridade'],
        codCarrinho: json['CodCarrinho'],
        nomeCarrinho: json['NomeCarrinho'],
        codigoBarrasCarrinho: json['CodigoBarrasCarrinho'],
        situacaoCarrinho: json['SituacaoCarrinho'],
        codLocalArmazenagem: json['CodLocalArmazenagem'],
        codProduto: json['CodProduto'],
        nomeProduto: json['NomeProduto'],
        codUnidadeMedida: json['CodUnidadeMedida'],
        nomeUnidadeMedida: json['NomeUnidadeMedida'],
        codGrupoProduto: json['CodGrupoProduto'],
        nomeGrupoProduto: json['NomeGrupoProduto'],
        codMarca: json['CodMarca'],
        nomeMarca: json['NomeMarca'],
        codSetorEstoque: json['CodSetorEstoque'],
        nomeSetorEstoque: json['NomeSetorEstoque'],
        codigoBarras: json['CodigoBarras'],
        codigoBarras2: json['CodigoBarras2'],
        codigoReferencia: json['CodigoReferencia'],
        codigoFornecedor: json['CodigoFornecedor'],
        codigoFabricante: json['CodigoFabricante'],
        codigoOriginal: json['CodigoOriginal'],
        endereco: json['Endereco'],
        enderecoDescricao: json['EnderecoDescricao'],
        quantidadeSeparacao:
            AppHelper.stringToDouble(json['QuantidadeSeparacao']),
        historico: json['Historico'],
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
      'CodLocalArmazenagem': codLocalArmazenagem,
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
      'CodigoBarras': codigoBarras,
      'CodigoBarras2': codigoBarras2,
      'CodigoReferencia': codigoReferencia,
      'CodigoFornecedor': codigoFornecedor,
      'CodigoFabricante': codigoFabricante,
      'CodigoOriginal': codigoOriginal,
      'Endereco': endereco,
      'EnderecoDescricao': enderecoDescricao,
      'QuantidadeSeparacao': quantidadeSeparacao.toStringAsFixed(4),
      'Historico': historico,
      'Observacao': observacao,
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
        codLocalArmazenagem: $codLocalArmazenagem,
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
        codigoBarras: $codigoBarras, 
        codigoBarras2: $codigoBarras2, 
        codigoReferencia: $codigoReferencia, 
        codigoFornecedor: $codigoFornecedor, 
        codigoFabricante: $codigoFabricante, 
        codigoOriginal: $codigoOriginal, 
        endereco: $endereco, 
        enderecoDescricao: $enderecoDescricao, 
        quantidadeSeparacao: $quantidadeSeparacao
        historico: $historico,
        observacao: $observacao,
    )''';
  }
}
