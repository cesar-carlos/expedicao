import 'package:flutter_test/flutter_test.dart';

import 'package:app_expedicao/src/model/pagination/paged_query.dart';

void main() {
  group('PagedQuery.collect', () {
    test('para na primeira página curta', () async {
      final pages = <int>[];

      final result = await PagedQuery.collect<int>(
        pageSize: 500,
        fetchPage: (page, pageSize) async {
          pages.add(page);
          expect(pageSize, 500);
          return [1, 2, 3];
        },
      );

      expect(pages, [1]);
      expect(result, [1, 2, 3]);
    });

    test('acumula páginas cheias até uma curta', () async {
      final result = await PagedQuery.collect<int>(
        pageSize: 2,
        fetchPage: (page, pageSize) async {
          if (page == 1) return [1, 2];
          if (page == 2) return [3, 4];
          return [5];
        },
      );

      expect(result, [1, 2, 3, 4, 5]);
    });

    test('estoura se o servidor nunca devolver página curta', () async {
      await expectLater(
        PagedQuery.collect<int>(
          pageSize: 2,
          maxPages: 3,
          fetchPage: (page, pageSize) async => [page, page],
        ),
        throwsStateError,
      );
    });
  });
}
