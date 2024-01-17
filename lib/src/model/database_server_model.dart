class DataBaseServerModel {
  final String userName;
  final String password;
  final String serverName;
  final String database;
  final String databaseName;
  final String port;

  DataBaseServerModel({
    required this.userName,
    required this.password,
    required this.serverName,
    required this.database,
    required this.databaseName,
    required this.port,
  });

  DataBaseServerModel copyWith({
    String? userName,
    String? password,
    String? serverName,
    String? database,
    String? databaseName,
    String? port,
  }) {
    return DataBaseServerModel(
      userName: userName ?? this.userName,
      password: password ?? this.password,
      serverName: serverName ?? this.serverName,
      database: database ?? this.database,
      databaseName: databaseName ?? this.databaseName,
      port: port ?? this.port,
    );
  }

  factory DataBaseServerModel.fromJson(Map map) {
    return DataBaseServerModel(
      userName: map['userName'],
      password: map['password'],
      serverName: map['serverName'],
      database: map['database'],
      databaseName: map['databaseName'],
      port: map['port'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'password': password,
      'serverName': serverName,
      'database': database,
      'databaseName': databaseName,
      'port': port,
    };
  }

  @override
  String toString() {
    return '''
      DataBaseServerModel(
        userName: $userName, 
        password: $password, 
        serverName: $serverName, 
        database: $database, 
        databaseName: $databaseName, 
        port: $port)
    ''';
  }
}
