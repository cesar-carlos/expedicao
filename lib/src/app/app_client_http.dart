import 'package:dio/dio.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_api_file_init.dart';

class AppClientHttp {
  final client = Dio();
  AppError? appError;
  late final Future<void> _ready;

  AppClientHttp() {
    _ready = confg();
  }

  Future<void> confg() async {
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
    } on DioException catch (err) {
      //TODO: Tratar erros status code
      appError = AppError(
        'Erro na requisição',
        details: err.toString(),
      );
    } catch (err) {
      throw Exception(err);
    }

    throw Exception('Erro desconhecido');
  }

  bool get hasError {
    return appError == null ? false : true;
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
