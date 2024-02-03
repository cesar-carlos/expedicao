class SendMutationsSocketModel {
  final String session;
  final String resposeIn;
  final List<Map<String, dynamic>> mutations;

  SendMutationsSocketModel({
    required this.session,
    required this.resposeIn,
    required this.mutations,
  });

  Map<String, dynamic> toJson() {
    return {
      "session": session,
      "resposeIn": resposeIn,
      "mutation": mutations,
    };
  }
}
