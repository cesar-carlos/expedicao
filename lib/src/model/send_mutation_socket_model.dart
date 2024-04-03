class SendMutationSocketModel {
  final String session;
  final String resposeIn;
  final Map<String, dynamic> mutation;

  SendMutationSocketModel({
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
}
