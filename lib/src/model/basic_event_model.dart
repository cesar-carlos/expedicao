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

  factory BasicEventModel.fromJson(Map<String, dynamic> json) {
    final mutation = json['mutation'] as List;
    return BasicEventModel(
      session: json['session'],
      resposeIn: json['resposeIn'],
      mutation: mutation.map((el) => el as Map<String, dynamic>).toList(),
    );
  }
}
