import 'package:get/get.dart';

import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/app/app_client_http.dart';
import 'package:app_expedicao/src/app/app_error.dart';

class AppProcessoExecutavel extends GetxController {
  final String _endPoint = '/processoexecutavel';
  final appClientHttp = Get.find<AppClientHttp>();
  late ProcessoExecutavelModel? _executavel;

  ProcessoExecutavelModel? get processoExecutavel => _executavel;

  Future<({ProcessoExecutavelModel? succes, AppError? error})>
      getProcessoExecutavel() async {
    try {
      final respose = await appClientHttp.get(_endPoint);
      if (respose.statusCode != 200) {
        const errorMessage = 'Error ao buscar processo executavel!';
        return (succes: null, error: AppError(errorMessage));
      }

      final output = ProcessoExecutavelModel.fromJson(respose.data.first);
      return (succes: output, error: null);
    } catch (err) {
      const errorMessage = 'Error ao buscar processo executavel!';
      return (succes: null, error: AppError(errorMessage));
    }
  }
}
