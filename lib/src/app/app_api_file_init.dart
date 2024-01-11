import 'dart:async';
import 'dart:convert';

import 'package:app_expedicao/src/model/api_server_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppApiFileInit {
  static const _configName = 'apiConfg';

  static FutureOr<ApiServerModel?> getConfg() async {
    final prefs = await SharedPreferences.getInstance();
    final String? confg = prefs.getString(AppApiFileInit._configName);
    if (confg == null) return null;

    final jsonConfig = jsonDecode(confg);
    return ApiServerModel.fromJson(jsonConfig);
  }

  static FutureOr<void> setConfg(ApiServerModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonConfig = jsonEncode(model.toJson());
    prefs.setString(AppApiFileInit._configName, jsonConfig);
  }

  static FutureOr<void> removeConfg() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(AppApiFileInit._configName);
  }

  static FutureOr<bool> hasConfg() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(AppApiFileInit._configName);
  }
}
