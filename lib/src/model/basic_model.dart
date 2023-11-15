abstract class BasicModel {
  factory BasicModel.fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();

  Map<String, dynamic> toJson() => throw UnimplementedError();
  BasicModel copyWith() => throw UnimplementedError();
}
