abstract class ExpedicaoItemSituacaoModel {
  static const String separado = 'SP';
  static const String cancelado = 'CA';
  static const String pendente = 'PE';
  static const String conferido = 'CO';
  static const String embalado = 'EM';
  static const String entregue = 'EN';
  static const String expedido = 'EX';
  static const String pausado = 'PA';
  static const String reiniciado = 'RE';
  static const String finalizado = 'FN';
  static const String vazio = '';

  static String getDescricao(String situacao) {
    return ExpedicaoItemSituacaoModel._situacao[situacao] ?? '';
  }

  static final Map<String, String> _situacao = {
    'SP': 'Separado',
    'CA': 'Cancelado',
    'PE': 'Pendente',
    'CO': 'Conferido',
    'EM': 'Embalado',
    'EN': 'Entregue',
    'EX': 'Expedido',
    'PA': 'Pausado',
    'RE': 'Reiniciado',
    '': ''
  };
}
