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
  final String? enderecoDescricao;
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
    this.enderecoDescricao,
    required this.codLocaArmazenagem,
    required this.nomeLocaArmazenagem,
    required this.quantidade,
    required this.quantidadeInterna,
    required this.quantidadeExterna,
    required this.quantidadeSeparacao,
  });

  ExpedicaoSepararItemConsultaModel copyWith({
    int? codEmpresa,
    int? codSepararEstoque,
    String? item,
    String? origem,
    int? codOrigem,
    String? itemOrigem,
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
    String? enderecoDescricao,
    int? codLocaArmazenagem,
    String? nomeLocaArmazenagem,
    double? quantidade,
    double? quantidadeInterna,
    double? quantidadeExterna,
    double? quantidadeSeparacao,
  }) {
    return ExpedicaoSepararItemConsultaModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codSepararEstoque: codSepararEstoque ?? this.codSepararEstoque,
      item: item ?? this.item,
      origem: origem ?? this.origem,
      codOrigem: codOrigem ?? this.codOrigem,
      itemOrigem: itemOrigem ?? this.itemOrigem,
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
      enderecoDescricao: enderecoDescricao ?? this.enderecoDescricao,
      codLocaArmazenagem: codLocaArmazenagem ?? this.codLocaArmazenagem,
      nomeLocaArmazenagem: nomeLocaArmazenagem ?? this.nomeLocaArmazenagem,
      quantidade: quantidade ?? this.quantidade,
      quantidadeInterna: quantidadeInterna ?? this.quantidadeInterna,
      quantidadeExterna: quantidadeExterna ?? this.quantidadeExterna,
      quantidadeSeparacao: quantidadeSeparacao ?? this.quantidadeSeparacao,
    );
  }

  factory ExpedicaoSepararItemConsultaModel.fromJson(
      Map<String, dynamic> json) {
    try {
      return ExpedicaoSepararItemConsultaModel(
        codEmpresa: json['CodEmpresa'],
        codSepararEstoque: json['CodSepararEstoque'],
        item: json['Item'],
        origem: json['Origem'],
        codOrigem: json['CodOrigem'],
        itemOrigem: json['ItemOrigem'],
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
        nomeSetorEstoque: json['NomeSetorEstoque'],
        ncm: json['NCM'] ?? '00000000',
        codigoBarras: json['CodigoBarras'],
        codigoBarras2: json['CodigoBarras2'],
        codigoReferencia: json['CodigoReferencia'],
        codigoFornecedor: json['CodigoFornecedor'],
        codigoFabricante: json['CodigoFabricante'],
        codigoOriginal: json['CodigoOriginal'],
        endereco: json['Endereco'],
        enderecoDescricao: json['EnderecoDescricao'],
        codLocaArmazenagem: json['CodLocaArmazenagem'],
        nomeLocaArmazenagem: json['NomeLocaArmazenagem'],
        quantidade: AppHelper.stringToDouble(json['Quantidade']),
        quantidadeInterna: AppHelper.stringToDouble(json['QuantidadeInterna']),
        quantidadeExterna: AppHelper.stringToDouble(json['QuantidadeExterna']),
        quantidadeSeparacao:
            AppHelper.stringToDouble(json['QuantidadeSeparacao']),
      );
    } catch (_) {
      rethrow;
    }
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
      'EnderecoDescricao': enderecoDescricao,
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
    return '''
      ExpedicaoSepararItemConsultaModel(
        codEmpresa: $codEmpresa, 
        codSepararEstoque: $codSepararEstoque, 
        item: $item, 
        origem: $origem, 
        codOrigem: $codOrigem, 
        itemOrigem: $itemOrigem, 
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
        codLocaArmazenagem: $codLocaArmazenagem, 
        nomeLocaArmazenagem: $nomeLocaArmazenagem, 
        quantidade: $quantidade, 
        quantidadeInterna: $quantidadeInterna, 
        quantidadeExterna: $quantidadeExterna, 
        quantidadeSeparacao: $quantidadeSeparacao
    )''';
  }
}
