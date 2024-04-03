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

  factory EstoqueProdutoConsultaModel.fromJson(Map<String, dynamic> json) {
    try {
      return EstoqueProdutoConsultaModel(
        codProduto: json['CodProduto'],
        nomeProduto: json['NomeProduto'],
        ativo: json['Ativo'],
        codTipoProduto: json['CodTipoProduto'],
        codUnidadeMedida: json['CodUnidadeMedida'],
        nomeUnidadeMedida: json['NomeUnidadeMedida'],
        codGrupoProduto: json['CodGrupoProduto'],
        nomeGrupoProduto: json['NomeGrupoProduto'],
        codMarca: json['CodMarca'],
        nomeMarca: json['NomeMarca'],
        codSetorEstoque: json['CodSetorEstoque'],
        ncm: json['NCM'],
        codigoBarras: json['CodigoBarras'],
        codigoBarras2: json['CodigoBarras2'],
        codigoReferencia: json['CodigoReferencia'],
        codigoFornecedor: json['CodigoFornecedor'],
        codigoFabricante: json['CodigoFabricante'],
        codigoOriginal: json['CodigoOriginal'],
        endereco: json['Endereco'],
        enderecoDescricao: json['EnderecoDescricao'],
      );
    } catch (e) {
      rethrow;
    }
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
          enderecoDescricao: $enderecoDescricao
    )''';
  }
}
