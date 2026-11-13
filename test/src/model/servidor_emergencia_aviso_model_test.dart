import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:app_expedicao/src/model/basic_event_model.dart';
import 'package:app_expedicao/src/model/servidor_emergencia_aviso_model.dart';

void main() {
  group('ServidorEmergenciaAvisoModel', () {
    test('le Data[0] sem Session', () {
      final event = BasicEventModel.parse({
        'Data': [
          {
            'Nivel': 'aviso',
            'Codigo': 'SERVIDOR_AVISO',
            'Mensagem': 'Servidor em manutencao em 10 minutos.',
            'Acao': 'nenhuma',
            'PrazoMs': 0,
            'EmitidoEm': '2026-11-13T12:00:00.000Z',
          },
        ],
      });

      final aviso = ServidorEmergenciaAvisoModel.fromMutation(event.mutation);
      expect(aviso, isNotNull);
      expect(event.session, isEmpty);
      expect(aviso!.nivel, 'aviso');
      expect(aviso.codigo, 'SERVIDOR_AVISO');
      expect(aviso.mensagem, 'Servidor em manutencao em 10 minutos.');
      expect(aviso.acao, 'nenhuma');
      expect(aviso.vaiDesconectar, isFalse);
      expect(aviso.titulo, 'Aviso do servidor');
      expect(aviso.detalhe, aviso.mensagem);
    });

    test('aceita JSON string e Acao=desconectar', () {
      final event = BasicEventModel.parse(
        jsonEncode({
          'Data': [
            {
              'Nivel': 'desconectar',
              'Codigo': 'SERVIDOR_DESCONECTAR',
              'Mensagem': 'Sessao encerrada pelo operador.',
              'Acao': 'desconectar',
              'PrazoMs': 10000,
            },
          ],
        }),
      );

      final aviso = ServidorEmergenciaAvisoModel.fromMutation(event.mutation);
      expect(aviso, isNotNull);
      expect(aviso!.vaiDesconectar, isTrue);
      expect(aviso.prazoMs, 10000);
      expect(aviso.titulo, 'Sessão será encerrada');
      expect(aviso.detalhe, contains('10 segundos'));
      expect(aviso.detalhe, isNot(contains('Erro ao')));
    });

    test('urgente e mutation vazia', () {
      final urgente = ServidorEmergenciaAvisoModel.fromJson({
        'Nivel': 'urgente',
        'Mensagem': 'Base saturada',
      });
      expect(urgente.titulo, 'Aviso urgente');
      expect(urgente.acao, 'nenhuma');

      expect(ServidorEmergenciaAvisoModel.fromMutation(const []), isNull);
    });
  });
}
