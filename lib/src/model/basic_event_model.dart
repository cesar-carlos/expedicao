class BasicEventModel {
  String session;
  String resposeIn;

  List<Map<String, dynamic>> mutation;

  BasicEventModel({
    required this.session,
    required this.resposeIn,
    required this.mutation,
  });

  factory BasicEventModel.empty() {
    return BasicEventModel(
      session: '',
      resposeIn: '',
      mutation: [],
    );
  }

  BasicEventModel copyWith({
    String? session,
    String? resposeIn,
    List<Map<String, dynamic>>? mutation,
  }) {
    return BasicEventModel(
      session: session ?? this.session,
      resposeIn: resposeIn ?? this.resposeIn,
      mutation: mutation ?? this.mutation,
    );
  }

  factory BasicEventModel.fromJson(Map<String, dynamic> json) {
    try {
      return BasicEventModel(
        session: json['Session'],
        resposeIn: json['ResposeIn'],
        mutation: List<Map<String, dynamic>>.from(json['Mutation']),
      );
    } catch (_) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'Session': session,
      'ResposeIn': resposeIn,
      'Mutation': mutation,
    };
  }

  @override
  String toString() {
    return '''
      BasicEventModel(
        session: $session, 
        resposeIn: $resposeIn, 
        mutation: $mutation
      )''';
  }
}
