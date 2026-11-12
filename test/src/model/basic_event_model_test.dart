import 'package:flutter_test/flutter_test.dart';

import 'package:app_expedicao/src/model/basic_event_model.dart';

void main() {
  group('BasicEventModel.parse', () {
    test('lê Mutation como lista a partir de JSON string', () {
      const json =
          '{"Session":"abc","ResponseIn":"r1","Mutation":[{"CodEmpresa":1}]}';

      final event = BasicEventModel.parse(json);

      expect(event.session, 'abc');
      expect(event.responseIn, 'r1');
      expect(event.mutation, [
        {'CodEmpresa': 1},
      ]);
    });

    test('lê Mutation como objeto', () {
      final event = BasicEventModel.parse({
        'Session': 's',
        'ResponseIn': 'r',
        'Mutation': {'Item': '001'},
      });

      expect(event.mutation, [
        {'Item': '001'},
      ]);
    });

    test('usa Data quando Mutation não vem', () {
      final event = BasicEventModel.parse({
        'Session': 's',
        'ResponseIn': 'r',
        'Data': [
          {'CodProduto': 10},
        ],
      });

      expect(event.mutation, [
        {'CodProduto': 10},
      ]);
    });

    test('trata DTO solto como uma linha de mutation', () {
      final event = BasicEventModel.parse({
        'Session': 's',
        'ResponseIn': 'r',
        'CodEmpresa': 1,
        'CodSepararEstoque': 99,
      });

      expect(event.mutation, [
        {'CodEmpresa': 1, 'CodSepararEstoque': 99},
      ]);
    });

    test('payload inválido vira modelo vazio', () {
      final event = BasicEventModel.parse('não é json');

      expect(event.session, isEmpty);
      expect(event.responseIn, isEmpty);
      expect(event.mutation, isEmpty);
    });
  });
}
