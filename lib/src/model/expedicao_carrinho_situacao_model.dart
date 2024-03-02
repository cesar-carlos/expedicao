abstract class ExpedicaoCarrinhoSituacaoModel {
  static const emSeparacao = 'EM SEPARACAO';
  static const liberado = 'LIBERADO';
  //static const separando = 'SEPARANDO';
  static const emConferencia = 'EM CONFERENCIA';
  static const separado = 'SEPARADO';
  //static const conferindo = 'CONFERINDO';
  static const conferido = 'CONFERIDO';
  //static const cancelado = 'CANCELADO';
  //static const finalizado = 'FINALIZADO';
  //static const aguardando = 'AGUARDANDO';

  static Map<String, String> situacao = {
    emSeparacao: 'Em Separação',
    liberado: 'Liberado',
    //separando: 'Separando',

    emConferencia: 'Em Conferência',
    separado: 'Separado',
    //conferindo: 'Conferindo',
    conferido: 'Conferido',
    //cancelado: 'Cancelado',
    //finalizado: 'Finalizado',
    //aguardando: 'Aguardando',
    '': ''
  };
}
