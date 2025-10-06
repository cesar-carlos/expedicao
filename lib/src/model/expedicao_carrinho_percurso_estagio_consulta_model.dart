import 'package:app_expedicao/src/app/app_helper.dart';

class ExpedicaoCarrinhoPercursoEstagioConsultaModel {
  final int codEmpresa;
  final int codCarrinhoPercurso;
  final String item;
  final int codPercursoEstagio;
  final String origem;
  final int codOrigem;
  String situacao;
  final String carrinhoAgrupador;
  final int? codCarrinhoAgrupador;
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
    required this.carrinhoAgrupador,
    this.codCarrinhoAgrupador,
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
    String? carrinhoAgrupador,
    int? codCarrinhoAgrupador,
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
      carrinhoAgrupador: carrinhoAgrupador ?? this.carrinhoAgrupador,
      codCarrinhoAgrupador: codCarrinhoAgrupador ?? this.codCarrinhoAgrupador,
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
      Map<String, dynamic> json) {
    try {
      return ExpedicaoCarrinhoPercursoEstagioConsultaModel(
        codEmpresa: json['CodEmpresa'],
        codCarrinhoPercurso: json['CodCarrinhoPercurso'],
        item: json['Item'],
        codPercursoEstagio: json['CodPercursoEstagio'],
        origem: json['Origem'],
        codOrigem: json['CodOrigem'],
        situacao: json['Situacao'],
        carrinhoAgrupador: json['CarrinhoAgrupador'],
        codCarrinhoAgrupador: json['CodCarrinhoAgrupador'],
        codCarrinho: json['CodCarrinho'],
        nomeCarrinho: json['NomeCarrinho'],
        codigoBarrasCarrinho: json['CodigoBarrasCarrinho'],
        ativo: json['Ativo'],
        codUsuarioInicio: json['CodUsuarioInicio'],
        nomeUsuarioInicio: json['NomeUsuarioInicio'],
        dataInicio: AppHelper.tryStringToDate(json['DataInicio']),
        horaInicio: json['HoraInicio'] ?? '00:00:00',
        codUsuarioFinalizacao: json['CodUsuarioFinalizacao'],
        nomeUsuarioFinalizacao: json['NomeUsuarioFinalizacao'],
        dataFinalizacao:
            AppHelper.tryStringToDateOrNull(json['DataFinalizacao']),
        horaFinalizacao: json['HoraFinalizacao'],
        codSetorEstoque: json['CodSetorEstoque'],
        nomeSetorEstoque: json['NomeSetorEstoque'],
      );
    } catch (_) {
      rethrow;
    }
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
      'CarrinhoAgrupador': carrinhoAgrupador,
      'CodCarrinhoAgrupador': codCarrinhoAgrupador,
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
        carrinhoAgrupador: $carrinhoAgrupador,
        codCarrinhoAgrupador: $codCarrinhoAgrupador,
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
    )''';
  }
}
