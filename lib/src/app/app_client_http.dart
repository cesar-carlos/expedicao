import 'package:dio/dio.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_api_file_init.dart';

class AppClientHttp {
  static const connectTimeout = Duration(seconds: 8);
  static const receiveTimeout = Duration(seconds: 20);

  final client = Dio(
    BaseOptions(
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: receiveTimeout,
    ),
  );
  AppError? appError;
  late final Future<void> _ready;

  AppClientHttp() {
    _ready = applyConfig();
  }

  Future<void> applyConfig() async {
    final apiServerModel = await AppApiFileInit.getConfg();
    if (apiServerModel == null) return;

    client.options.baseUrl =
        'http://${apiServerModel.hostServer}:${apiServerModel.port}';
  }

  Future<Response<T>> get<T>(String endPoint) async {
    try {
      await _ready;
      appError = null;
      return await client.get<T>(endPoint);
    } on AppError catch (err) {
      appError = err;
      rethrow;
    } on DioException catch (err) {
      appError = AppError.fromUnknown(
        err.response?.data ?? err.message ?? err,
        code: err.response?.statusCode,
        details: err.toString(),
      );
      throw appError!;
    } catch (err) {
      appError = AppError.fromUnknown(err);
      throw appError!;
    }
  }

  Future<bool> ping({required String host, required String port}) async {
    final url = 'http://$host:$port/health';
    try {
      final response = await client.get<dynamic>(
        url,
        options: Options(
          receiveTimeout: connectTimeout,
          sendTimeout: connectTimeout,
        ),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  bool get hasError {
    return appError != null;
  }

  AppError? getError() {
    return appError;
  }

  void setClearError() {
    appError = null;
  }

  void close() {
    client.close();
  }
}
