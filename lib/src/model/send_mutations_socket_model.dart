class SendMutationsSocketModel {
  final String session;
  final String resposeIn;
  final List<Map<String, dynamic>> mutation;

  SendMutationsSocketModel({
    required this.session,
    required this.resposeIn,
    required this.mutation,
  });

  Map<String, dynamic> toJson() {
    return {
      "Session": session,
      "ResposeIn": resposeIn,
      "Mutation": mutation,
    };
  }

  @override
  String toString() {
    return '''
      SendMutationsSocketModel(
        session: $session, 
        resposeIn: $resposeIn, 
        mutation: $mutation
    )''';
  }
}
