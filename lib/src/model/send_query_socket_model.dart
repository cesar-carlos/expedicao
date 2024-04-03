class SendQuerySocketModel {
  String session;
  String resposeIn;
  String where;

  SendQuerySocketModel({
    required this.session,
    required this.resposeIn,
    required this.where,
  });

  Map<String, dynamic> toJson() {
    return {
      "session": session,
      "resposeIn": resposeIn,
      "where": where,
    };
  }

  @override
  String toString() {
    return '''
      SendQuerySocketModel(
        session: $session, 
        resposeIn: $resposeIn, 
        where: $where
    )''';
  }
}
