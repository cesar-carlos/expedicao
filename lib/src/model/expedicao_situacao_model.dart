abstract class ExpedicaoSituacaoModel {
  static const aguardando = 'AGUARDANDO';
  static const emPausa = 'EM PAUSA';
  static const emAndamento = 'EM ANDAMENTO';
  static const emSeparacao = 'EM SEPARACAO';
  static const emConverencia = 'EM CONFERENCIA';
  static const cancelada = 'CANCELADA';
  static const devolvida = 'DEVOLVIDA';
  static const separando = 'SEPARANDO';
  static const separado = 'SEPARADO';
  static const conferindo = 'CONFERINDO';
  static const conferido = 'CONFERIDO';
  static const entregue = 'ENTREGUE';
  static const finalizada = 'FINALIZADA';
  static const naoLocalizada = 'NÃO LOCALIZADO';

  static Map<String, String> situacao = {
    aguardando: 'Aguardando',
    emPausa: 'Em Pausa',
    emAndamento: 'Em Andamento',
    emSeparacao: 'Em Separação',
    emConverencia: 'Em Conferência',
    cancelada: 'Cancelada',
    devolvida: 'Devolvida',
    separando: 'Separando',
    separado: 'Separado',
    conferindo: 'Conferindo',
    conferido: 'Conferido',
    entregue: 'Entregue',
    naoLocalizada: 'Não Localizada',
    '': ''
  };
}
