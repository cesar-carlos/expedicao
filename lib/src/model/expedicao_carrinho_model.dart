import 'package:app_expedicao/src/model/expedicao_carrinho_consulta_model.dart';

class ExpedicaoCarrinhoModel {
  final int codEmpresa;
  final int codCarrinho;
  final String descricao;
  final String ativo;
  final String codigoBarras;
  final String situacao;

  ExpedicaoCarrinhoModel({
    required this.codEmpresa,
    required this.codCarrinho,
    required this.descricao,
    required this.ativo,
    required this.codigoBarras,
    required this.situacao,
  });

  ExpedicaoCarrinhoModel copyWith({
    int? codEmpresa,
    int? codCarrinho,
    String? descricao,
    String? ativo,
    String? codigoBarras,
    String? situacao,
  }) {
    return ExpedicaoCarrinhoModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codCarrinho: codCarrinho ?? this.codCarrinho,
      descricao: descricao ?? this.descricao,
      ativo: ativo ?? this.ativo,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      situacao: situacao ?? this.situacao,
    );
  }

  factory ExpedicaoCarrinhoModel.fromConsulta(
      ExpedicaoCarrinhoConsultaModel model) {
    return ExpedicaoCarrinhoModel(
      codEmpresa: model.codEmpresa,
      codCarrinho: model.codCarrinho,
      descricao: model.descricaoCarrinho,
      ativo: model.ativo,
      codigoBarras: model.codigoBarras,
      situacao: model.situacao,
    );
  }

  factory ExpedicaoCarrinhoModel.fromJson(Map<String, dynamic> map) {
    return ExpedicaoCarrinhoModel(
      codEmpresa: map['CodEmpresa'],
      codCarrinho: map['CodCarrinho'],
      descricao: map['Descricao'],
      ativo: map['Ativo'],
      codigoBarras: map['CodigoBarras'],
      situacao: map['Situacao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodCarrinho': codCarrinho,
      'Descricao': descricao,
      'Ativo': ativo,
      'CodigoBarras': codigoBarras,
      'Situacao': situacao,
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaoCarrinhoModel(
        codEmpresa: $codEmpresa, 
        codCarrinho: $codCarrinho, 
        descricao: $descricao, 
        ativo: $ativo, 
        codigoBarras: $codigoBarras, 
        situacao: $situacao)
    ''';
  }
}
