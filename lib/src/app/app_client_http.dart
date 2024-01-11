import 'package:dio/dio.dart';

import 'package:app_expedicao/src/app/app_error.dart';
import 'package:app_expedicao/src/app/app_api_file_init.dart';
import 'package:app_expedicao/src/app/app_error_code.dart';

class AppClientHttp {
  final client = Dio();
  AppError? appError;

  AppClientHttp() {
    confg();
  }

  Future<void> confg() async {
    final apiServerModel = await AppApiFileInit.getConfg();
    client.options.baseUrl =
        'http://${apiServerModel!.hostServer}:${apiServerModel.port}';
  }

  Future<Response<T>> get<T>(String endPoint) async {
    try {
      appError = null;
      return await client.get<T>(endPoint);
    } on DioException catch (err) {
      //TODO: Tratar erros status code
      appError = AppError(
        AppErrorCode.serverNotFound,
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
