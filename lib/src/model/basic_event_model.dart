import 'dart:convert';

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
    return BasicEventModel(session: '', responseIn: '', mutation: []);
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

  factory BasicEventModel.parse(dynamic data) {
    try {
      final decoded = data is String ? jsonDecode(data) : data;
      if (decoded is! Map) return BasicEventModel.empty();
      return BasicEventModel.fromJson(Map<String, dynamic>.from(decoded));
    } catch (_) {
      return BasicEventModel.empty();
    }
  }

  factory BasicEventModel.fromJson(Map<String, dynamic> json) {
    return BasicEventModel(
      session: json['Session']?.toString() ?? '',
      responseIn: json['ResponseIn']?.toString() ?? '',
      mutation: _mutationOf(json),
    );
  }

  static List<Map<String, dynamic>> _mutationOf(Map<String, dynamic> json) {
    final value = json['Mutation'] ?? json['Data'];
    if (value is List) {
      return value
          .whereType<Map>()
          .map((row) => Map<String, dynamic>.from(row))
          .toList();
    }
    if (value is Map) {
      return [Map<String, dynamic>.from(value)];
    }

    final leftover = Map<String, dynamic>.from(json)
      ..remove('Session')
      ..remove('ResponseIn')
      ..remove('Error')
      ..remove('Code');
    if (leftover.isEmpty) return [];
    return [leftover];
  }

  Map<String, dynamic> toJson() {
    return {'Session': session, 'ResponseIn': responseIn, 'Mutation': mutation};
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
