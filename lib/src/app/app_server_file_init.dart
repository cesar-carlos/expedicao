import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_expedicao/src/model/database_server_model.dart';

class AppServerFileInit {
  static const _configName = 'databaseConfg';

  static FutureOr<DataBaseServerModel?> getConfg() async {
    final prefs = await SharedPreferences.getInstance();
    final String? confg = prefs.getString(AppServerFileInit._configName);
    if (confg == null) return null;

    final jsonConfig = jsonDecode(confg);
    return DataBaseServerModel.fromJson(jsonConfig);
  }

  static FutureOr<void> setConfg(DataBaseServerModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonConfig = jsonEncode(model.toJson());
    prefs.setString(AppServerFileInit._configName, jsonConfig);
  }

  static FutureOr<void> removeConfg() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(AppServerFileInit._configName);
  }

  static FutureOr<bool> hasConfg() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(AppServerFileInit._configName);
  }
}
