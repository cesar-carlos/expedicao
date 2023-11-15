import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_processo_executavel.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/routes/app_router.dart';
import 'package:app_expedicao/src/app/app_error.dart';

class SplashController extends GetxController {
  final _controller = Get.find<AppProcessoExecutavel>();
  late ({ProcessoExecutavelModel? succes, AppError? error}) _processoExec;

  final _isLoad = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _onInit();
  }

  _onInit() async {
    _isLoad.value = true;
    _processoExec = await _controller.getProcessoExecutavel();
    _isLoad.value = false;
    nextPage();
  }

  bool get isLoad => _isLoad.value;
  AppError? get error => _processoExec.error;

  void nextPage() async {
    Get.find<ProcessoExecutavelModel>().update(_processoExec.succes!);
    Get.offNamed(AppRouter.separar, arguments: _processoExec.succes);
  }
}
