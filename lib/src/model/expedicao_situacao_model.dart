abstract class ExpedicaoSituacaoModel {
  static const aguardando = 'AGUARDANDO';
  static const emPausa = 'EM PAUSA';
  static const emAndamento = 'EM ANDAMENTO';
  static const emSeparacao = 'EM SEPARACAO';
  static const emConverencia = 'EM CONFERENCIA';

  static const separando = 'SEPARANDO';
  static const separado = 'SEPARADO';
  static const conferindo = 'CONFERINDO';
  static const conferido = 'CONFERIDO';
  static const embalando = 'EMBALANDO';
  static const embalado = 'EMBALADO';
  static const entregue = 'ENTREGUE';
  static const finalizada = 'FINALIZADA';
  static const cancelada = 'CANCELADA';
  static const devolvida = 'DEVOLVIDA';
  static const agrupado = 'AGRUPADO';
  static const naoLocalizada = 'NÃO LOCALIZADO';

  static Map<String, String> situacao = {
    aguardando: 'Aguardando',
    emPausa: 'Em Pausa',
    emAndamento: 'Em Andamento',
    emSeparacao: 'Em Separação',
    emConverencia: 'Em Conferência',
    separando: 'Separando',
    separado: 'Separado',
    conferindo: 'Conferindo',
    conferido: 'Conferido',
    embalando: 'Embalando',
    embalado: 'Embalado',
    entregue: 'Entregue',
    finalizada: 'Finalizada',
    cancelada: 'Cancelada',
    devolvida: 'Devolvida',
    agrupado: 'Agrupado',
    naoLocalizada: 'Não Localizada',
    '': ''
  };
}
