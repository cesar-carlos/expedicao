abstract class BasicModel {
  factory BasicModel.fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();

  Map<String, dynamic> toJson();
  BasicModel copyWith();
}
