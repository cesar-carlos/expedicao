enum OrderBy { ASC, DESC }

class SendQuerySocketModel {
  String session;
  String responseIn;
  String where;
  int limit;
  OrderBy orderBy;

  SendQuerySocketModel({
    required this.session,
    required this.responseIn,
    required this.where,
    this.limit = 0,
    this.orderBy = OrderBy.ASC,
  });

  Map<String, dynamic> toJson() {
    return {
      "Session": session,
      "ResponseIn": responseIn,
      "Where": where,
      "Limit": limit,
      "OrderBy": orderBy.toString().split('.').last,
    };
  }

  @override
  String toString() {
    return '''
      SendQuerySocketModel(
        session: $session, 
        responseIn: $responseIn, 
        where: $where
        limit: $limit
        orderBy: $orderBy
    )''';
  }
}
