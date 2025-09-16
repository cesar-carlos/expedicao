/// Enum for order direction
enum OrderDirection {
  asc('ASC'),
  desc('DESC');

  const OrderDirection(this.value);
  final String value;
}

/// Represents an ORDER BY clause
class OrderBy {
  final String field;
  final OrderDirection direction;

  const OrderBy({required this.field, this.direction = OrderDirection.asc});

  /// Creates an ascending order
  factory OrderBy.asc(String field) {
    return OrderBy(field: field, direction: OrderDirection.asc);
  }

  /// Creates a descending order
  factory OrderBy.desc(String field) {
    return OrderBy(field: field, direction: OrderDirection.desc);
  }

  /// Converts to SQL ORDER BY string
  String toSqlString() {
    return '$field ${direction.value}';
  }

  @override
  String toString() {
    return 'OrderBy(field: $field, direction: ${direction.value})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderBy &&
        other.field == field &&
        other.direction == direction;
  }

  @override
  int get hashCode => Object.hash(field, direction);
}

/// Collection of multiple ORDER BY clauses
class OrderByCollection {
  final List<OrderBy> _orders = [];

  /// Adds an ascending order
  OrderByCollection asc(String field) {
    _orders.add(OrderBy.asc(field));
    return this;
  }

  /// Adds a descending order
  OrderByCollection desc(String field) {
    _orders.add(OrderBy.desc(field));
    return this;
  }

  /// Adds a custom order
  OrderByCollection add(OrderBy order) {
    _orders.add(order);
    return this;
  }

  /// Gets all orders as unmodifiable list
  List<OrderBy> get orders => List.unmodifiable(_orders);

  /// Checks if collection is empty
  bool get isEmpty => _orders.isEmpty;

  /// Checks if collection is not empty
  bool get isNotEmpty => _orders.isNotEmpty;

  /// Converts to SQL ORDER BY string
  String toSqlString() {
    if (_orders.isEmpty) return '';
    return 'ORDER BY ${_orders.map((o) => o.toSqlString()).join(', ')}';
  }

  /// Converts to query parameter string
  String toQueryString() {
    if (_orders.isEmpty) return '';

    final fields = _orders.map((o) => o.field).join(',');
    final directions = _orders.map((o) => o.direction.value).join(',');

    return 'order_by=$fields&order_direction=$directions';
  }

  /// Clears all orders
  void clear() {
    _orders.clear();
  }

  @override
  String toString() {
    return 'OrderByCollection(orders: ${_orders.length})';
  }
}
