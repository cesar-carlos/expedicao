import 'dart:convert';

class ProcessoExecutavelModel {
  int codProcessoExecutavel;
  int codEmpresa;
  int codFilial;
  String status;
  String contexto;
  String origem;
  int codOrigem;
  String? itemOrigem;
  DateTime dataAbertura;
  int codUsuario;
  String nomeUsuario;
  int? codSetorEstoque;
  String? codContaFinanceira;
  int? codPeriodoCaixa;
  String? statusPeriodoCaixa;
  String usuarioWindows;
  String nomeComputador;
  String bancoDados;

  ProcessoExecutavelModel({
    required this.codProcessoExecutavel,
    required this.codEmpresa,
    required this.codFilial,
    required this.status,
    required this.contexto,
    required this.origem,
    required this.codOrigem,
    this.itemOrigem,
    required this.dataAbertura,
    required this.codUsuario,
    required this.nomeUsuario,
    this.codSetorEstoque,
    this.codContaFinanceira,
    this.codPeriodoCaixa,
    this.statusPeriodoCaixa,
    required this.usuarioWindows,
    required this.nomeComputador,
    required this.bancoDados,
  });

  ProcessoExecutavelModel copyWith({
    int? codProcessoExecutavel,
    int? codEmpresa,
    int? codFilial,
    String? status,
    String? contexto,
    String? origem,
    int? codOrigem,
    String? itemOrigem,
    DateTime? dataAbertura,
    int? codUsuario,
    String? nomeUsuario,
    int? codSetorEstoque,
    String? codContaFinanceira,
    int? codPeriodoCaixa,
    String? statusPeriodoCaixa,
    String? usuarioWindows,
    String? nomeComputador,
    String? bancoDados,
  }) {
    return ProcessoExecutavelModel(
      codProcessoExecutavel:
          codProcessoExecutavel ?? this.codProcessoExecutavel,
      codEmpresa: codEmpresa ?? this.codEmpresa,
      codFilial: codFilial ?? this.codFilial,
      status: status ?? this.status,
      contexto: contexto ?? this.contexto,
      origem: origem ?? this.origem,
      codOrigem: codOrigem ?? this.codOrigem,
      itemOrigem: itemOrigem ?? this.itemOrigem,
      dataAbertura: dataAbertura ?? this.dataAbertura,
      codUsuario: codUsuario ?? this.codUsuario,
      nomeUsuario: nomeUsuario ?? this.nomeUsuario,
      codSetorEstoque: codSetorEstoque ?? this.codSetorEstoque,
      codContaFinanceira: codContaFinanceira ?? this.codContaFinanceira,
      codPeriodoCaixa: codPeriodoCaixa ?? this.codPeriodoCaixa,
      statusPeriodoCaixa: statusPeriodoCaixa ?? this.statusPeriodoCaixa,
      usuarioWindows: usuarioWindows ?? this.usuarioWindows,
      nomeComputador: nomeComputador ?? this.nomeComputador,
      bancoDados: bancoDados ?? this.bancoDados,
    );
  }

  factory ProcessoExecutavelModel.empty() {
    return ProcessoExecutavelModel(
      codProcessoExecutavel: 0,
      codEmpresa: 0,
      codFilial: 0,
      status: '',
      contexto: '',
      origem: '',
      codOrigem: 0,
      itemOrigem: null,
      dataAbertura: DateTime.now(),
      codUsuario: 0,
      nomeUsuario: '',
      codSetorEstoque: null,
      codContaFinanceira: null,
      codPeriodoCaixa: null,
      statusPeriodoCaixa: null,
      usuarioWindows: '',
      nomeComputador: '',
      bancoDados: '',
    );
  }

  update(ProcessoExecutavelModel input) {
    codProcessoExecutavel = input.codProcessoExecutavel;
    codEmpresa = input.codEmpresa;
    codFilial = input.codFilial;
    status = input.status;
    contexto = input.contexto;
    origem = input.origem;
    codOrigem = input.codOrigem;
    itemOrigem = input.itemOrigem;
    dataAbertura = input.dataAbertura;
    codUsuario = input.codUsuario;
    nomeUsuario = input.nomeUsuario;
    codSetorEstoque = input.codSetorEstoque;
    codContaFinanceira = input.codContaFinanceira;
    codPeriodoCaixa = input.codPeriodoCaixa;
    statusPeriodoCaixa = input.statusPeriodoCaixa;
    usuarioWindows = input.usuarioWindows;
    nomeComputador = input.nomeComputador;
    bancoDados = input.bancoDados;
  }

  factory ProcessoExecutavelModel.fromJson(Map map) {
    return ProcessoExecutavelModel(
      codProcessoExecutavel: map['CodProcessoExecutavel'],
      codEmpresa: map['CodEmpresa'],
      codFilial: map['CodFilial'],
      status: map['Status'],
      contexto: map['Contexto'],
      origem: map['Origem'],
      codOrigem: map['CodOrigem'],
      itemOrigem: map['ItemOrigem'],
      dataAbertura:
          DateTime.parse(map['DataAbertura'].toString().replaceAll('/', '')),
      codUsuario: map['CodUsuario'],
      nomeUsuario: map['NomeUsuario'],
      codSetorEstoque: map['CodSetorEstoque'],
      codContaFinanceira: map['CodContaFinanceira'],
      codPeriodoCaixa: map['CodPeriodoCaixa'],
      statusPeriodoCaixa: map['StatusPeriodoCaixa'],
      usuarioWindows: map['UsuarioWindows'],
      nomeComputador: map['NomeComputador'],
      bancoDados: map['BancoDados'],
    );
  }

  factory ProcessoExecutavelModel.fromBase64(String texto) {
    var bytes = base64.decode(texto);
    final text = utf8.decode(bytes);
    return ProcessoExecutavelModel.fromJson(jsonDecode(text));
  }

  Map<String, dynamic> toJson() {
    return {
      'CodProcessoExecutavel': codProcessoExecutavel,
      'CodEmpresa': codEmpresa,
      'CodFilial': codFilial,
      'Status': status,
      'Contexto': contexto,
      'Origem': origem,
      'CodOrigem': codOrigem,
      'ItemOrigem': itemOrigem,
      'DataAbertura': dataAbertura.toIso8601String(),
      'CodUsuario': codUsuario,
      'NomeUsuario': nomeUsuario,
      'CodSetorEstoque': codSetorEstoque,
      'CodContaFinanceira': codContaFinanceira,
      'CodPeriodoCaixa': codPeriodoCaixa,
      'StatusPeriodoCaixa': statusPeriodoCaixa,
      'UsuarioWindows': usuarioWindows,
      'NomeComputador': nomeComputador,
      'BancoDados': bancoDados,
    };
  }

  @override
  String toString() {
    return '''
      ProcessoExecutavelModel(
        codProcessoExecutavel: $codProcessoExecutavel, 
        codEmpresa: $codEmpresa, 
        codFilial: $codFilial, 
        status: $status, 
        contexto: $contexto, 
        origem: $origem, 
        codOrigem: $codOrigem, 
        itemOrigem: $itemOrigem, 
        dataAbertura: $dataAbertura, 
        codUsuario: $codUsuario, 
        nomeUsuario: $nomeUsuario, 
        codSetorEstoque: $codSetorEstoque,
        codContaFinanceira: $codContaFinanceira, 
        codPeriodoCaixa: $codPeriodoCaixa, 
        statusPeriodoCaixa: $statusPeriodoCaixa, 
        usuarioWindows: $usuarioWindows, 
        nomeComputador: $nomeComputador, 
        bancoDados: $bancoDados)
      ''';
  }
}
