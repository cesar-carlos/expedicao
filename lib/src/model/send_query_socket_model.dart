enum OrderBy { ASC, DESC }

class SendQuerySocketModel {
  String session;
  String resposeIn;
  String where;
  int limit;
  OrderBy orderBy;

  SendQuerySocketModel({
    required this.session,
    required this.resposeIn,
    required this.where,
    this.limit = 0,
    this.orderBy = OrderBy.ASC,
  });

  Map<String, dynamic> toJson() {
    return {
      "Session": session,
      "ResposeIn": resposeIn,
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
        resposeIn: $resposeIn, 
        where: $where
        limit: $limit
        orderBy: $orderBy
    )''';
  }
}
