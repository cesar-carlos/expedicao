import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoConferirItemConsultaModel {
  final int codEmpresa;
  final int codConferir;
  final String item;
  final String origem;
  final int codOrigem;
  final int codCarrinhoPercurso;
  final String itemCarrinhoPercurso;
  final String situacaoCarrinhoPercurso;
  final int codCarrinho;
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
    required this.situacaoCarrinhoPercurso,
    required this.codCarrinho,
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
    String? situacaoCarrinhoPercurso,
    int? codCarrinho,
    int? codProduto,
    String? nomeProduto,
    String? codTipoProduto,
    String? codUnidadeMedida,
    String? nomeUnidadeMedida,
    int? codGrupoProduto,
    String? nomeGrupoProduto,
    int? codMarca,
    String? nomeMarca,
    int? codSetorEstoque,
    String? nomeSetorEstoque,
    String? codigoBarras,
    String? codigoBarras2,
    String? codigoReferencia,
    String? codigoFornecedor,
    String? codigoFabricante,
    String? codigoOriginal,
    String? endereco,
    String? enderecoDescricao,
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
      situacaoCarrinhoPercurso:
          situacaoCarrinhoPercurso ?? this.situacaoCarrinhoPercurso,
      codCarrinho: codCarrinho ?? this.codCarrinho,
      codProduto: codProduto ?? this.codProduto,
      nomeProduto: nomeProduto ?? this.nomeProduto,
      codUnidadeMedida: codUnidadeMedida ?? this.codUnidadeMedida,
      nomeUnidadeMedida: nomeUnidadeMedida ?? this.nomeUnidadeMedida,
      codGrupoProduto: codGrupoProduto ?? this.codGrupoProduto,
      nomeGrupoProduto: nomeGrupoProduto ?? this.nomeGrupoProduto,
      codMarca: codMarca ?? this.codMarca,
      nomeMarca: nomeMarca ?? this.nomeMarca,
      codSetorEstoque: codSetorEstoque ?? this.codSetorEstoque,
      nomeSetorEstoque: nomeSetorEstoque ?? this.nomeSetorEstoque,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      codigoBarras2: codigoBarras2 ?? this.codigoBarras2,
      codigoReferencia: codigoReferencia ?? this.codigoReferencia,
      codigoFornecedor: codigoFornecedor ?? this.codigoFornecedor,
      codigoFabricante: codigoFabricante ?? this.codigoFabricante,
      codigoOriginal: codigoOriginal ?? this.codigoOriginal,
      endereco: endereco ?? this.endereco,
      enderecoDescricao: enderecoDescricao ?? this.enderecoDescricao,
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
      situacaoCarrinhoPercurso: map['SituacaoCarrinhoPercurso'],
      codCarrinho: map['CodCarrinho'],
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
      codigoBarras: map['CodigoBarras'],
      codigoBarras2: map['CodigoBarras2'],
      codigoReferencia: map['CodigoReferencia'],
      codigoFornecedor: map['CodigoFornecedor'],
      codigoFabricante: map['CodigoFabricante'],
      codigoOriginal: map['CodigoOriginal'],
      endereco: map['Endereco'],
      enderecoDescricao: map['EnderecoDescricao'],
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
      'SituacaoCarrinhoPercurso': situacaoCarrinhoPercurso,
      'CodCarrinho': codCarrinho,
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
      'Quantidade': quantidade.toStringAsFixed(4),
      'QuantidadeConferida': quantidadeConferida.toStringAsFixed(4),
    };
  }

  isComplited() {
    return quantidade == quantidadeConferida;
  }

  @override
  String toString() {
    return '''
      ExpedicaoConferirItemConsultaModel(
        codEmpresa: $codEmpresa, 
        codConferir: $codConferir, 
        item: $item, 
        origem: $origem, 
        codOrigem: $codOrigem, 
        codCarrinhoPercurso: $codCarrinhoPercurso, 
        itemCarrinhoPercurso: $itemCarrinhoPercurso, 
        situacaoCarrinhoPercurso: $situacaoCarrinhoPercurso,
        codCarrinho: $codCarrinho, 
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
        quantidade: $quantidade, 
        quantidadeConferida: $quantidadeConferida)
    ''';
  }
}
