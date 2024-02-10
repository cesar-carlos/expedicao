import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoCarrinhoPercursoEstagioConsultaModel {
  final int codEmpresa;
  final int codCarrinhoPercurso;
  final String item;
  final int codPercursoEstagio;
  final String origem;
  final int codOrigem;
  final String situacao;
  final int codCarrinho;
  final String nomeCarrinho;
  final String codigoBarrasCarrinho;
  final String ativo;
  final int codUsuarioInicio;
  final String nomeUsuarioInicio;
  final DateTime dataInicio;
  final String horaInicio;
  final int? codUsuarioFinalizacao;
  final String? nomeUsuarioFinalizacao;
  final DateTime? dataFinalizacao;
  final String? horaFinalizacao;
  final int? codSetorEstoque;
  final String? nomeSetorEstoque;

  ExpedicaoCarrinhoPercursoEstagioConsultaModel({
    required this.codEmpresa,
    required this.codCarrinhoPercurso,
    required this.item,
    required this.codPercursoEstagio,
    required this.origem,
    required this.codOrigem,
    required this.situacao,
    required this.codCarrinho,
    required this.nomeCarrinho,
    required this.codigoBarrasCarrinho,
    required this.ativo,
    required this.codUsuarioInicio,
    required this.nomeUsuarioInicio,
    required this.dataInicio,
    required this.horaInicio,
    this.codUsuarioFinalizacao,
    this.nomeUsuarioFinalizacao,
    this.dataFinalizacao,
    this.horaFinalizacao,
    this.codSetorEstoque,
    this.nomeSetorEstoque,
  });

  ExpedicaoCarrinhoPercursoEstagioConsultaModel copyWith({
    int? codEmpresa,
    int? codCarrinhoPercurso,
    String? item,
    int? codPercursoEstagio,
    String? origem,
    int? codOrigem,
    String? situacao,
    int? codCarrinho,
    String? nomeCarrinho,
    String? codigoBarrasCarrinho,
    String? ativo,
    int? codUsuarioInicio,
    String? nomeUsuarioInicio,
    DateTime? dataInicio,
    String? horaInicio,
    int? codUsuarioFinalizacao,
    String? nomeUsuarioFinalizacao,
    DateTime? dataFinalizacao,
    String? horaFinalizacao,
    int? codSetorEstoque,
    String? nomeSetorEstoque,
  }) {
    return ExpedicaoCarrinhoPercursoEstagioConsultaModel(
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codCarrinhoPercurso: codCarrinhoPercurso ?? this.codCarrinhoPercurso,
      item: item ?? this.item,
      codPercursoEstagio: codPercursoEstagio ?? this.codPercursoEstagio,
      origem: origem ?? this.origem,
      codOrigem: codOrigem ?? this.codOrigem,
      situacao: situacao ?? this.situacao,
      codCarrinho: codCarrinho ?? this.codCarrinho,
      nomeCarrinho: nomeCarrinho ?? this.nomeCarrinho,
      codigoBarrasCarrinho: codigoBarrasCarrinho ?? this.codigoBarrasCarrinho,
      ativo: ativo ?? this.ativo,
      codUsuarioInicio: codUsuarioInicio ?? this.codUsuarioInicio,
      nomeUsuarioInicio: nomeUsuarioInicio ?? this.nomeUsuarioInicio,
      dataInicio: dataInicio ?? this.dataInicio,
      horaInicio: horaInicio ?? this.horaInicio,
      codUsuarioFinalizacao:
          codUsuarioFinalizacao ?? this.codUsuarioFinalizacao,
      nomeUsuarioFinalizacao:
          nomeUsuarioFinalizacao ?? this.nomeUsuarioFinalizacao,
      dataFinalizacao: dataFinalizacao ?? this.dataFinalizacao,
      horaFinalizacao: horaFinalizacao ?? this.horaFinalizacao,
      codSetorEstoque: codSetorEstoque ?? this.codSetorEstoque,
      nomeSetorEstoque: nomeSetorEstoque ?? this.nomeSetorEstoque,
    );
  }

  factory ExpedicaoCarrinhoPercursoEstagioConsultaModel.fromJson(
      Map<String, dynamic> map) {
    return ExpedicaoCarrinhoPercursoEstagioConsultaModel(
      codEmpresa: map['CodEmpresa'],
      codCarrinhoPercurso: map['CodCarrinhoPercurso'],
      item: map['Item'],
      codPercursoEstagio: map['CodPercursoEstagio'],
      origem: map['Origem'],
      codOrigem: map['CodOrigem'],
      situacao: map['Situacao'],
      codCarrinho: map['CodCarrinho'],
      nomeCarrinho: map['NomeCarrinho'],
      codigoBarrasCarrinho: map['CodigoBarrasCarrinho'],
      ativo: map['Ativo'],
      codUsuarioInicio: map['CodUsuarioInicio'],
      nomeUsuarioInicio: map['NomeUsuarioInicio'],
      dataInicio: AppHelper.tryStringToDate(map['DataInicio']),
      horaInicio: map['HoraInicio'] ?? '00:00:00',
      codUsuarioFinalizacao: map['CodUsuarioFinalizacao'],
      nomeUsuarioFinalizacao: map['NomeUsuarioFinalizacao'],
      dataFinalizacao: AppHelper.tryStringToDateOrNull(map['DataFinalizacao']),
      horaFinalizacao: map['HoraFinalizacao'],
      codSetorEstoque: map['CodSetorEstoque'],
      nomeSetorEstoque: map['NomeSetorEstoque'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CodEmpresa': codEmpresa,
      'CodCarrinhoPercurso': codCarrinhoPercurso,
      'Item': item,
      'CodPercursoEstagio': codPercursoEstagio,
      'Origem': origem,
      'CodOrigem': codOrigem,
      'Situacao': situacao,
      'CodCarrinho': codCarrinho,
      'NomeCarrinho': nomeCarrinho,
      'CodigoBarrasCarrinho': codigoBarrasCarrinho,
      'Ativo': ativo,
      'CodUsuarioInicio': codUsuarioInicio,
      'NomeUsuarioInicio': nomeUsuarioInicio,
      'DataInicio': dataInicio.toIso8601String(),
      'HoraInicio': horaInicio,
      'CodUsuarioFinalizacao': codUsuarioFinalizacao,
      'NomeUsuarioFinalizacao': nomeUsuarioFinalizacao,
      'DataFinalizacao': dataFinalizacao?.toIso8601String(),
      'HoraFinalizacao': horaFinalizacao,
      'CodSetorEstoque': codSetorEstoque,
      'NomeSetorEstoque': nomeSetorEstoque,
    };
  }

  @override
  String toString() {
    return '''
      ExpedicaoCarrinhoPercursoConsultaModel(
        codEmpresa: $codEmpresa, 
        codCarrinhoPercurso: $codCarrinhoPercurso, 
        item: $item, 
        codPercursoEstagio: $codPercursoEstagio, 
        origem: $origem, 
        codOrigem: $codOrigem, 
        situacao: $situacao, 
        codCarrinho: $codCarrinho, 
        nomeCarrinho: $nomeCarrinho, 
        codigoBarrasCarrinho: $codigoBarrasCarrinho, 
        ativo: $ativo, 
        codUsuarioInicio: $codUsuarioInicio, 
        nomeUsuarioInicio: $nomeUsuarioInicio, 
        dataInicio: $dataInicio, 
        horaInicio: $horaInicio, 
        codUsuarioFinalizacao: $codUsuarioFinalizacao,
        nomeUsuarioFinalizacao: $nomeUsuarioFinalizacao,
        dataFinalizacao: $dataFinalizacao, 
        horaFinalizacao: $horaFinalizacao, 
        codSetorEstoque: $codSetorEstoque, 
        nomeSetorEstoque: $nomeSetorEstoque
    ''';
  }
}
