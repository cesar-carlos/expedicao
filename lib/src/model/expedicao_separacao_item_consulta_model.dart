import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaSeparacaoItemConsultaModel {
  final int codEmpresa;
  final int codSepararEstoque;
  final String item;
  final String sessionId;
  final String situacao;
  final int codCarrinho;
  final String nomeCarrinho;
  final String codigoBarrasCarrinho;
  final int codCarrinhoPercurso;
  final String itemCarrinhoPercurso;
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
  final int codSeparador;
  final String nomeSeparador;
  final DateTime dataSeparacao;
  final String horaSeparacao;
  final double quantidade;

  ExpedicaSeparacaoItemConsultaModel({
    required this.codEmpresa,
    required this.codSepararEstoque,
    required this.item,
    required this.sessionId,
    required this.situacao,
    required this.codCarrinho,
    required this.nomeCarrinho,
    required this.codigoBarrasCarrinho,
    required this.codCarrinhoPercurso,
    required this.itemCarrinhoPercurso,
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
    required this.codSeparador,
    required this.nomeSeparador,
    required this.dataSeparacao,
    required this.horaSeparacao,
    required this.quantidade,
  });

  ExpedicaSeparacaoItemConsultaModel copyWith({
    int? codEmpresa,
    int? codSepararEstoque,
    String? item,
    String? sessionId,
    String? situacao,
    int? codCarrinho,
    String? nomeCarrinho,
    String? codigoBarrasCarrinho,
    int? codCarrinhoPercurso,
    String? itemCarrinhoPercurso,
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
    int? codSeparador,
    String? nomeSeparador,
    DateTime? dataSeparacao,
    String? horaSeparacao,
    double? quantidade,
  }) {
    return ExpedicaSeparacaoItemConsultaModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codSepararEstoque: codSepararEstoque ?? this.codSepararEstoque,
      item: item ?? this.item,
      sessionId: sessionId ?? this.sessionId,
      situacao: situacao ?? this.situacao,
      codCarrinho: codCarrinho ?? this.codCarrinho,
      nomeCarrinho: nomeCarrinho ?? this.nomeCarrinho,
      codigoBarrasCarrinho: codigoBarrasCarrinho ?? this.codigoBarrasCarrinho,
      codCarrinhoPercurso: codCarrinhoPercurso ?? this.codCarrinhoPercurso,
      itemCarrinhoPercurso: itemCarrinhoPercurso ?? this.itemCarrinhoPercurso,
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
      ncm: ncm ?? this.ncm,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      codigoBarras2: codigoBarras2 ?? this.codigoBarras2,
      codigoReferencia: codigoReferencia ?? this.codigoReferencia,
      codigoFornecedor: codigoFornecedor ?? this.codigoFornecedor,
      codigoFabricante: codigoFabricante ?? this.codigoFabricante,
      codigoOriginal: codigoOriginal ?? this.codigoOriginal,
      endereco: endereco ?? this.endereco,
      enderecoDescricao: enderecoDescricao ?? this.enderecoDescricao,
      codSeparador: codSeparador ?? this.codSeparador,
      nomeSeparador: nomeSeparador ?? this.nomeSeparador,
      dataSeparacao: dataSeparacao ?? this.dataSeparacao,
      horaSeparacao: horaSeparacao ?? this.horaSeparacao,
      quantidade: quantidade ?? this.quantidade,
    );
  }

  factory ExpedicaSeparacaoItemConsultaModel.fromJson(
      Map<String, dynamic> json) {
    try {
      return ExpedicaSeparacaoItemConsultaModel(
        codEmpresa: json['CodEmpresa'],
        codSepararEstoque: json['CodSepararEstoque'],
        item: json['Item'],
        sessionId: json['SessionId'],
        situacao: json['Situacao'] ?? '',
        codCarrinho: json['CodCarrinho'],
        nomeCarrinho: json['NomeCarrinho'],
        codigoBarrasCarrinho: json['CodigoBarrasCarrinho'],
        codCarrinhoPercurso: json['CodCarrinhoPercurso'],
        itemCarrinhoPercurso: json['ItemCarrinhoPercurso'],
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
        ncm: json['NCM'] ?? '00000000',
        codigoBarras: json['CodigoBarras'],
        codigoBarras2: json['CodigoBarras2'],
        codigoReferencia: json['CodigoReferencia'],
        codigoFornecedor: json['CodigoFornecedor'],
        codigoFabricante: json['CodigoFabricante'],
        codigoOriginal: json['CodigoOriginal'],
        endereco: json['Endereco'],
        enderecoDescricao: json['EnderecoDescricao'],
        codSeparador: json['CodSeparador'],
        nomeSeparador: json['NomeSeparador'],
        dataSeparacao: AppHelper.tryStringToDate(json['DataSeparacao']),
        horaSeparacao: json['HoraSeparacao'],
        quantidade: AppHelper.stringToDouble(json['Quantidade']),
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
      'SessionId': sessionId,
      'Situacao': situacao,
      'CodCarrinho': codCarrinho,
      'NomeCarrinho': nomeCarrinho,
      'CodigoBarrasCarrinho': codigoBarrasCarrinho,
      'CodCarrinhoPercurso': codCarrinhoPercurso,
      'ItemCarrinhoPercurso': itemCarrinhoPercurso,
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
      'CodSeparador': codSeparador,
      'NomeSeparador': nomeSeparador,
      'DataSeparacao': dataSeparacao.toIso8601String(),
      'HoraSeparacao': horaSeparacao,
      'Quantidade': quantidade.toStringAsFixed(4),
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaSeparacaoItemConsultaModel(
        codEmpresa: $codEmpresa, 
        codSepararEstoque: $codSepararEstoque, 
        item: $item, 
        sessionId: $sessionId, 
        situacao: $situacao, 
        codCarrinho: $codCarrinho, 
        nomeCarrinho: $nomeCarrinho, 
        codigoBarrasCarrinho: $codigoBarrasCarrinho, 
        codCarrinhoPercurso: $codCarrinhoPercurso, 
        itemCarrinhoPercurso: $itemCarrinhoPercurso, 
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
        codSeparador: $codSeparador, 
        nomeSeparador: $nomeSeparador, 
        dataSeparacao: $dataSeparacao, 
        horaSeparacao: $horaSeparacao, 
        quantidade: $quantidade
    )''';
  }
}
