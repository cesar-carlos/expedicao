/// DTO for sending query requests through socket connection
class SendQuerySocketModel {
  final String session;
  final String responseIn;
  final String? where;
  final String? pagination;
  final String? orderBy;

  const SendQuerySocketModel({
    required this.session,
    required this.responseIn,
    this.where,
    this.pagination,
    this.orderBy,
  });

  /// Creates a copy of this DTO with updated values
  SendQuerySocketModel copyWith({
    String? session,
    String? responseIn,
    String? where,
    String? pagination,
    String? orderBy,
  }) {
    return SendQuerySocketModel(
      session: session ?? this.session,
      responseIn: responseIn ?? this.responseIn,
      where: where ?? this.where,
      pagination: pagination ?? this.pagination,
      orderBy: orderBy ?? this.orderBy,
    );
  }

  /// Converts this DTO to JSON format for socket communication
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'Session': session,
      'ResponseIn': responseIn,
    };

    // Only include optional fields if they have values
    if (where != null && where!.isNotEmpty) {
      json['Where'] = where;
    }
    if (pagination != null && pagination!.isNotEmpty) {
      json['Pagination'] = pagination;
    }
    if (orderBy != null && orderBy!.isNotEmpty) {
      json['OrderBy'] = orderBy;
    }

    return json;
  }

  /// Creates a DTO from JSON response
  factory SendQuerySocketModel.fromJson(Map<String, dynamic> json) {
    return SendQuerySocketModel(
      session: json['Session'] as String,
      responseIn: json['ResponseIn'] as String,
      where: json['Where'] as String?,
      pagination: json['Pagination'] as String?,
      orderBy: json['OrderBy'] as String?,
    );
  }

  @override
  String toString() {
    return 'SendQuerySocketModel('
        'session: $session, '
        'responseIn: $responseIn, '
        'where: $where, '
        'pagination: $pagination, '
        'orderBy: $orderBy)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SendQuerySocketModel &&
        other.session == session &&
        other.responseIn == responseIn &&
        other.where == where &&
        other.pagination == pagination &&
        other.orderBy == orderBy;
  }

  @override
  int get hashCode {
    return Object.hash(session, responseIn, where, pagination, orderBy);
  }
}
