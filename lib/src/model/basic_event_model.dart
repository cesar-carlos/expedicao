class BasicEventModel {
  String session;
  String responseIn;

  List<Map<String, dynamic>> mutation;

  BasicEventModel({
    required this.session,
    required this.responseIn,
    required this.mutation,
  });

  factory BasicEventModel.empty() {
    return BasicEventModel(
      session: '',
      responseIn: '',
      mutation: [],
    );
  }

  BasicEventModel copyWith({
    String? session,
    String? responseIn,
    List<Map<String, dynamic>>? mutation,
  }) {
    return BasicEventModel(
      session: session ?? this.session,
      responseIn: responseIn ?? this.responseIn,
      mutation: mutation ?? this.mutation,
    );
  }

  factory BasicEventModel.fromJson(Map<String, dynamic> json) {
    try {
      return BasicEventModel(
        session: json['Session'],
        responseIn: json['ResponseIn'],
        mutation: List<Map<String, dynamic>>.from(json['Mutation']),
      );
    } catch (_) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'Session': session,
      'ResponseIn': responseIn,
      'Mutation': mutation,
    };
  }

  @override
  String toString() {
    return '''
      BasicEventModel(
        session: $session, 
        responseIn: $responseIn, 
        mutation: $mutation
      )''';
  }
}
