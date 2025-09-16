import 'query_builder.dart';

/// Extension for easy query building
extension QueryBuilderExtension on QueryBuilder {
  /// Creates a new QueryBuilder with default pagination
  static QueryBuilder withDefaultPagination({
    int limit = 20,
    int offset = 0,
    int page = 1,
  }) {
    return QueryBuilder().paginate(limit: limit, offset: offset, page: page);
  }

  /// Adds a date range filter
  QueryBuilder dateRange(String key, DateTime start, DateTime end) {
    return greaterThan(key, start).lessThan(key, end);
  }

  /// Adds a text search filter
  QueryBuilder search(String key, String searchTerm) {
    return like(key, '%$searchTerm%');
  }

  /// Adds a status filter
  QueryBuilder status(String status) {
    return equals('situacao', status);
  }

  /// Adds a code filter
  QueryBuilder code(String code) {
    return equals('codigo', code);
  }

  /// Orders by creation date (most recent first)
  QueryBuilder orderByNewest() {
    return orderByDesc('created_at');
  }

  /// Orders by creation date (oldest first)
  QueryBuilder orderByOldest() {
    return orderByAsc('created_at');
  }

  /// Orders by name alphabetically
  QueryBuilder orderByName() {
    return orderByAsc('nome');
  }

  /// Orders by status and then by date
  QueryBuilder orderByStatusAndDate() {
    return orderByAsc('situacao').orderByDesc('created_at');
  }

  /// Orders by priority (high to low) and then by date
  QueryBuilder orderByPriority() {
    return orderByDesc('prioridade').orderByDesc('created_at');
  }
}
