abstract class ExpedicaoSituacaoModel {
  static const aguardando = 'AGUARDANDO';
  static const emAndamento = 'EM ANDAMENTO';
  static const emPausa = 'EM PAUSA';
  static const finalizada = 'FINALIZADA';
  static const cancelada = 'CANCELADA';
  static const entregue = 'ENTREGUE';
  static const devolvida = 'DEVOLVIDA';
  static const separada = 'SEPARADA';
  static const separando = 'SEPARANDO';
  static const naoLocalizada = 'NÃO LOCALIZADO';

  static Map<String, String> situacao = {
    aguardando: 'Aguardando',
    emAndamento: 'Em Andamento',
    emPausa: 'Em Pausa',
    finalizada: 'Finalizada',
    cancelada: 'Cancelada',
    entregue: 'Entregue',
    devolvida: 'Devolvida',
    separada: 'Separada',
    separando: 'Separando',
    naoLocalizada: 'Não Localizada',
    '': ''
  };
}
