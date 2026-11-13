import 'package:flutter_test/flutter_test.dart';

import 'package:app_expedicao/src/model/pagination/pagination.dart';
import 'package:app_expedicao/src/model/pagination/query_builder.dart';

void main() {
  group('QueryBuilder.allRows', () {
    test('marca busca paginada de 500 e ordena por Item', () {
      final query = QueryBuilder().equals('CodEmpresa', 1).allRows();

      expect(query.fetchAllPages, isTrue);
      expect(query.fetchPageSize, Pagination.fetchPageSize);
      expect(query.buildPagination(), isEmpty);
      expect(query.buildOrderByQuery(), 'order_by=Item&order_direction=ASC');
    });

    test('aceita tamanho de página explícito', () {
      final query = QueryBuilder().allRows(pageSize: 200);

      expect(query.fetchPageSize, 200);
    });

    test('não troca um OrderBy que o chamador já definiu', () {
      final query = QueryBuilder().orderByDesc('CodProduto').allRows();

      expect(
        query.buildOrderByQuery(),
        'order_by=CodProduto&order_direction=DESC',
      );
    });

    test('thenBy entra depois do campo principal para OFFSET estável', () {
      final query = QueryBuilder().allRows(thenBy: ['ItemUnidadeMedida']);

      expect(
        query.buildOrderByQuery(),
        'order_by=Item,ItemUnidadeMedida&order_direction=ASC,ASC',
      );
    });

    test('sem allRows a paginação fica vazia para o servidor aplicar 1500', () {
      final query = QueryBuilder().equals('CodEmpresa', 1);

      expect(query.fetchAllPages, isFalse);
      expect(query.buildPagination(), isEmpty);
      expect(query.buildOrderByQuery(), isEmpty);
    });
  });

  group('QueryBuilder.withAllRows', () {
    test('não altera o builder original compartilhado entre selects', () {
      final original = QueryBuilder().equals('CodEmpresa', 1);
      final paged = original.withAllRows(orderField: 'CodCarrinho');

      expect(original.fetchAllPages, isFalse);
      expect(original.buildOrderByQuery(), isEmpty);
      expect(paged.fetchAllPages, isTrue);
      expect(
        paged.buildOrderByQuery(),
        'order_by=CodCarrinho&order_direction=ASC',
      );
      expect(paged.buildSqlWhere(), original.buildSqlWhere());
    });

    test('não troca allRows que o chamador já definiu', () {
      final query = QueryBuilder().allRows(thenBy: ['ItemUnidadeMedida']);
      final paged = query.withAllRows(orderField: 'CodCarrinho');

      expect(
        paged.buildOrderByQuery(),
        'order_by=Item,ItemUnidadeMedida&order_direction=ASC,ASC',
      );
    });

    test('não troca paginate explícito', () {
      final query = QueryBuilder().paginate(limit: 20, page: 2);
      final paged = query.withAllRows();

      expect(paged.fetchAllPages, isFalse);
      expect(paged.buildPagination(), 'LIMIT=20&OFFSET=20&PAGE=2');
    });
  });

  group('QueryBuilder.buildWhereList', () {
    test('manda lista { key, operator, value } em vez de SQL', () {
      final query = QueryBuilder()
          .equals('CodEmpresa', 1)
          .equals('CodConferir', 290)
          .notEquals('Situacao', 'CANCELADA');

      expect(query.buildWhereList(), [
        {'key': 'CodEmpresa', 'operator': '=', 'value': 1},
        {'key': 'CodConferir', 'operator': '=', 'value': 290},
        {'key': 'Situacao', 'operator': '!=', 'value': 'CANCELADA'},
      ]);
    });

    test('IN guarda lista de valores, não string interpolada', () {
      final query = QueryBuilder().inList('CodCarrinho', [10, 20]);

      expect(query.buildWhereList(), [
        {
          'key': 'CodCarrinho',
          'operator': 'IN',
          'value': [10, 20],
        },
      ]);
      expect(query.buildSqlWhere(), 'CodCarrinho IN (10,20)');
    });
  });
}
