import 'dart:convert';

import 'package:app_expedicao/src/model/api_server_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppApiFileInit {
  static const _configName = 'apiConfg';

  static ApiServerModel? _cached;
  static bool _hasCache = false;
  static Future<ApiServerModel?>? _pending;

  static Future<ApiServerModel?> getConfg() {
    if (_hasCache) return Future.value(_cached);
    return _pending ??= _readConfg();
  }

  static Future<ApiServerModel?> _readConfg() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? confg = prefs.getString(_configName);
      if (confg == null) {
        _cached = null;
      } else {
        final jsonConfig = jsonDecode(confg);
        _cached = ApiServerModel.fromJson(jsonConfig);
      }

      _hasCache = true;
      return _cached;
    } finally {
      _pending = null;
    }
  }

  static Future<void> setConfg(ApiServerModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonConfig = jsonEncode(model.toJson());
    await prefs.setString(_configName, jsonConfig);
    _cached = model;
    _hasCache = true;
  }

  static Future<void> removeConfg() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_configName);
    _cached = null;
    _hasCache = true;
  }

  static Future<bool> hasConfg() async {
    final confg = await getConfg();
    return confg != null;
  }
}
