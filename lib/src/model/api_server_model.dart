class ApiServerModel {
  final String hostServer;
  final String port;

  ApiServerModel({
    required this.hostServer,
    required this.port,
  });

  ApiServerModel copyWith({
    String? hostServer,
    String? port,
  }) {
    return ApiServerModel(
      hostServer: hostServer ?? this.hostServer,
      port: port ?? this.port,
    );
  }

  factory ApiServerModel.fromJson(Map<String, dynamic> map) {
    return ApiServerModel(
      hostServer: map['hostServer'],
      port: map['port'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hostServer': hostServer,
      'port': port,
    };
  }
}
