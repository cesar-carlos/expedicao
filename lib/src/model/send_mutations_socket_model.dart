class SendMutationsSocketModel {
  final String session;
  final String responseIn;
  final List<Map<String, dynamic>> mutation;

  SendMutationsSocketModel({
    required this.session,
    required this.responseIn,
    required this.mutation,
  });

  Map<String, dynamic> toJson() {
    return {
      "Session": session,
      "ResponseIn": responseIn,
      "Mutation": mutation,
    };
  }

  @override
  String toString() {
    return '''
      SendMutationsSocketModel(
        session: $session, 
        responseIn: $responseIn, 
        mutation: $mutation
    )''';
  }
}
