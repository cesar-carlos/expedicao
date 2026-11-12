import 'package:flutter_test/flutter_test.dart';

import 'package:app_expedicao/src/app/app_socket_listen_log.dart';

void main() {
  group('AppSocketListenLog', () {
    test('reconhece canais de situação da separação e do carrinho', () {
      expect(
        AppSocketListenLog.isSituacaoChannel('separar.update.listen'),
        isTrue,
      );
      expect(
        AppSocketListenLog.isSituacaoChannel(
          'carrinho.percurso.estagio.update.listen',
        ),
        isTrue,
      );
      expect(
        AppSocketListenLog.isSituacaoChannel('conferir.update.listen'),
        isTrue,
      );
      expect(
        AppSocketListenLog.isSituacaoChannel('separacao.item.insert.listen'),
        isFalse,
      );
      expect(
        AppSocketListenLog.isListenLogChannel('separacao.item.insert.listen'),
        isTrue,
      );
    });

    test('reconhece sessao propria no envelope ou na linha', () {
      expect(
        AppSocketListenLog.isOwnSession(
          envelopeSession: 'abc',
          socketId: 'abc',
        ),
        isTrue,
      );
      expect(
        AppSocketListenLog.isOwnSession(
          envelopeSession: 'outro',
          socketId: 'abc',
          rowSessionId: 'abc',
        ),
        isTrue,
      );
      expect(
        AppSocketListenLog.isOwnSession(
          envelopeSession: 'outro',
          socketId: 'abc',
          rowSessionId: 'xyz',
        ),
        isFalse,
      );
    });

    test('extrai situacao de mutation mista', () {
      expect(AppSocketListenLog.asInt('290500'), 290500);
      expect(AppSocketListenLog.asString(' SEPARADO '), 'SEPARADO');
      expect(
        AppSocketListenLog.situacoesOf([
          {'CodSepararEstoque': 1, 'Situacao': 'SEPARANDO'},
          {'CodCarrinho': 2, 'Situacao': 'SEPARADO'},
          {'Item': '00001'},
        ]),
        ['SEPARANDO', 'SEPARADO'],
      );
    });
  });
}
