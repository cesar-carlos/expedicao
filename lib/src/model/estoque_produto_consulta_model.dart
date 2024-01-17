class EstoqueProdutoConsultaModel {
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
  final String? ncm;
  final String? codigoBarras;
  final String? codigoBarras2;
  final String? codigoReferencia;
  final String? codigoFornecedor;
  final String? codigoFabricante;
  final String? codigoOriginal;
  final String? endereco;
  final String? enderecoDescricao;

  EstoqueProdutoConsultaModel({
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
    this.ncm,
    this.codigoBarras,
    this.codigoBarras2,
    this.codigoReferencia,
    this.codigoFornecedor,
    this.codigoFabricante,
    this.codigoOriginal,
    this.endereco,
    this.enderecoDescricao,
  });

  factory EstoqueProdutoConsultaModel.fromJson(Map map) {
    return EstoqueProdutoConsultaModel(
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
      ncm: map['NCM'],
      codigoBarras: map['CodigoBarras'],
      codigoBarras2: map['CodigoBarras2'],
      codigoReferencia: map['CodigoReferencia'],
      codigoFornecedor: map['CodigoFornecedor'],
      codigoFabricante: map['CodigoFabricante'],
      codigoOriginal: map['CodigoOriginal'],
      endereco: map['Endereco'],
      enderecoDescricao: map['EnderecoDescricao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'NCM': ncm,
      'CodigoBarras': codigoBarras,
      'CodigoBarras2': codigoBarras2,
      'CodigoReferencia': codigoReferencia,
      'CodigoFornecedor': codigoFornecedor,
      'CodigoFabricante': codigoFabricante,
      'CodigoOriginal': codigoOriginal,
      'Endereco': endereco,
      'EnderecoDescricao': enderecoDescricao,
    };
  }

  @override
  String toString() {
    return '''
      EstoqueProdutoConsultaModel(
          codProduto: $codProduto, 
          nomeProduto: $nomeProduto, 
          ativo: $ativo, 
          codTipoProduto: $codTipoProduto, 
          codUnidadeMedida: $codUnidadeMedida, 
          nomeUnidadeMedida: $nomeUnidadeMedida, 
          codGrupoProduto: $codGrupoProduto, 
          nomeGrupoProduto: $nomeGrupoProduto, 
          codMarca: $codMarca, 
          nomeMarca: $nomeMarca, 
          codSetorEstoque: $codSetorEstoque, 
          ncm: $ncm, 
          codigoBarras: $codigoBarras, 
          codigoBarras2: $codigoBarras2, 
          codigoReferencia: $codigoReferencia, 
          codigoFornecedor: $codigoFornecedor, 
          codigoFabricante: $codigoFabricante, 
          codigoOriginal: $codigoOriginal, 
          endereco: $endereco, 
          enderecoDescricao: $enderecoDescricao)
    ''';
  }
}
