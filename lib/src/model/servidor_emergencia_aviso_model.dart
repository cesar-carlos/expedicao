/// Aviso do canal `servidor.emergencia.listen`. Família `ExpedicaoBasicListenEvent`.
/// Não tem `Session` — não filtrar por sessão.
class ServidorEmergenciaAvisoModel {
  final String nivel;
  final String codigo;
  final String mensagem;
  final String acao;
  final int prazoMs;
  final String? emitidoEm;

  const ServidorEmergenciaAvisoModel({
    required this.nivel,
    required this.codigo,
    required this.mensagem,
    required this.acao,
    required this.prazoMs,
    this.emitidoEm,
  });

  bool get vaiDesconectar => acao == 'desconectar';

  String get titulo {
    if (vaiDesconectar || nivel == 'desconectar') {
      return 'Sessão será encerrada';
    }
    if (nivel == 'urgente') return 'Aviso urgente';
    return 'Aviso do servidor';
  }

  String get detalhe {
    if (!vaiDesconectar || prazoMs <= 0) return mensagem;
    final seconds = (prazoMs / 1000).ceil();
    final unidade = seconds == 1 ? 'segundo' : 'segundos';
    return '$mensagem\n\nA conexão será encerrada em $seconds $unidade.';
  }

  factory ServidorEmergenciaAvisoModel.fromJson(Map<String, dynamic> json) {
    return ServidorEmergenciaAvisoModel(
      nivel: json['Nivel']?.toString() ?? 'aviso',
      codigo: json['Codigo']?.toString() ?? '',
      mensagem: json['Mensagem']?.toString() ?? '',
      acao: json['Acao']?.toString() ?? 'nenhuma',
      prazoMs: _prazoOf(json['PrazoMs']),
      emitidoEm: json['EmitidoEm']?.toString(),
    );
  }

  static ServidorEmergenciaAvisoModel? fromMutation(
    List<Map<String, dynamic>> mutation,
  ) {
    if (mutation.isEmpty) return null;
    return ServidorEmergenciaAvisoModel.fromJson(mutation.first);
  }

  static int _prazoOf(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
