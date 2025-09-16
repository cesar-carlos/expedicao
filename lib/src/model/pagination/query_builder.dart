import 'query_param.dart';
import 'pagination.dart';
import 'query_order_by.dart';

/// Query builder for constructing complex queries
class QueryBuilder {
  Pagination? _pagination;
  final List<QueryParam> _params = [];
  final List<OrderBy> _orderBy = [];

  /// Adds a parameter to the query
  QueryBuilder addParam<P>(String key, P value, {String operator = '='}) {
    _params.add(QueryParam.createWithOperator(key, value, operator));
    return this;
  }

  /// Adds a parameter with equals operator
  QueryBuilder equals<P>(String key, P value) {
    return addParam(key, value, operator: '=');
  }

  /// Adds a parameter with not equals operator
  QueryBuilder notEquals<P>(String key, P value) {
    return addParam(key, value, operator: '!=');
  }

  /// Adds a parameter with like operator
  QueryBuilder like(String key, String value) {
    return addParam(key, value, operator: 'LIKE');
  }

  /// Adds a parameter with greater than operator
  QueryBuilder greaterThan<P>(String key, P value) {
    return addParam(key, value, operator: '>');
  }

  /// Adds a parameter with less than operator
  QueryBuilder lessThan<P>(String key, P value) {
    return addParam(key, value, operator: '<');
  }

  /// Adds a parameter with in operator
  QueryBuilder inList<P>(String key, List<P> values) {
    final valueString = values.map((v) => _formatValue(v)).join(',');
    return addParam(key, valueString, operator: 'IN');
  }

  /// Adds pagination to the query
  QueryBuilder paginate({int limit = 10, int offset = 0, int page = 1}) {
    _pagination = Pagination(limit: limit, offset: offset, page: page);
    return this;
  }

  /// Adds ORDER BY clause
  QueryBuilder orderBy(
    String field, {
    OrderDirection direction = OrderDirection.asc,
  }) {
    _orderBy.add(OrderBy(field: field, direction: direction));
    return this;
  }

  /// Adds ascending ORDER BY
  QueryBuilder orderByAsc(String field) {
    _orderBy.add(OrderBy.asc(field));
    return this;
  }

  /// Adds descending ORDER BY
  QueryBuilder orderByDesc(String field) {
    _orderBy.add(OrderBy.desc(field));
    return this;
  }

  /// Adds multiple ORDER BY clauses
  QueryBuilder orderByMultiple(List<OrderBy> orders) {
    _orderBy.addAll(orders);
    return this;
  }

  /// Builds only the query parameters string (without pagination)
  String buildQuery() {
    return _params.map((param) => param.toQueryString()).join('&');
  }

  /// Builds SQL WHERE clause
  String buildSqlWhere() {
    if (_params.isEmpty) return '';
    return _params.map((param) => param.toSqlString()).join(' AND ');
  }

  /// Builds only the pagination string
  String buildPagination() {
    if (_pagination == null) {
      return '';
    }
    return _pagination!.toQueryString();
  }

  /// Builds ORDER BY string for SQL
  String buildOrderBySql() {
    if (_orderBy.isEmpty) return '';
    return 'ORDER BY ${_orderBy.map((o) => o.toSqlString()).join(', ')}';
  }

  /// Builds ORDER BY string for query parameters
  String buildOrderByQuery() {
    if (_orderBy.isEmpty) return '';

    final fields = _orderBy.map((o) => o.field).join(',');
    final directions = _orderBy.map((o) => o.direction.value).join(',');

    return 'order_by=$fields&order_direction=$directions';
  }

  /// Builds complete query with all components
  String buildCompleteQuery() {
    final parts = <String>[];

    // Query parameters
    final queryParams = buildQuery();
    if (queryParams.isNotEmpty) {
      parts.add(queryParams);
    }

    // Pagination
    final pagination = buildPagination();
    if (pagination.isNotEmpty) {
      parts.add(pagination);
    }

    // Order by
    final orderBy = buildOrderByQuery();
    if (orderBy.isNotEmpty) {
      parts.add(orderBy);
    }

    return parts.join('&');
  }

  /// Gets all parameters as a list
  List<QueryParam> get params => List.unmodifiable(_params);

  /// Gets pagination if set
  Pagination? get pagination => _pagination;

  /// Gets ORDER BY clauses
  List<OrderBy> get orderByClauses => List.unmodifiable(_orderBy);

  /// Clears all parameters
  void clear() {
    _params.clear();
    _pagination = null;
    _orderBy.clear();
  }

  /// Formats a value for query string
  String _formatValue(dynamic value) {
    if (value is String) {
      return "'$value'";
    } else if (value is DateTime) {
      return "'${value.toIso8601String()}'";
    } else {
      return value.toString();
    }
  }

  @override
  String toString() {
    return 'QueryBuilder(params: ${_params.length}, pagination: $_pagination, orderBy: ${_orderBy.length})';
  }
}
