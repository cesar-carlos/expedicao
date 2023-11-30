import 'package:dio/dio.dart';

import 'package:app_expedicao/src/app/app_error.dart';

class AppClientHttp {
  final client = Dio();
  AppError? appError;

  AppClientHttp() {
    client.options.baseUrl = 'http://localhost:3001';
  }

  Future<Response<T>> get<T>(String endPoint) async {
    try {
      appError = null;
      return await client.get<T>(endPoint);
    } on DioException catch (err) {
      appError = AppError('Erro na requisição', details: err.toString());
    } catch (err) {
      throw Exception(err);
    }

    throw Exception('Erro desconhecido');
  }

  bool get hasError {
    return appError == null ? false : true;
  }

  getError() {
    return appError;
  }

  setClearError() {
    appError = null;
  }

  void close() {
    client.close();
  }
}
