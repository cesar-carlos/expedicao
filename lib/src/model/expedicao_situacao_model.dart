abstract class ExpedicaoSituacaoModel {
  static const aguardando = 'AGUARDANDO';
  static const emAndamento = 'EM ANDAMENTO';
  static const emPausa = 'EM PAUSA';
  static const finalizada = 'FINALIZADA';
  static const cancelada = 'CANCELADA';
  static const entregue = 'ENTREGUE';
  static const devolvida = 'DEVOLVIDA';
  static const separando = 'SEPARANDO';
  static const conferido = 'CONFERIDO';

  static const naoLocalizada = 'NÃO LOCALIZADO';

  static Map<String, String> situacao = {
    aguardando: 'Aguardando',
    emAndamento: 'Em Andamento',
    emPausa: 'Em Pausa',
    cancelada: 'Cancelada',
    entregue: 'Entregue',
    devolvida: 'Devolvida',
    separando: 'Separando',
    conferido: 'Conferido',
    naoLocalizada: 'Não Localizada',
    '': ''
  };
}
