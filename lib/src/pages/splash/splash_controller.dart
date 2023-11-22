import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/service/separar_consulta_services.dart';
import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_processo_executavel.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/routes/app_router.dart';
import 'package:app_expedicao/src/app/app_error.dart';

class SplashController extends GetxController {
  final _controller = Get.find<AppProcessoExecutavel>();
  late ({ProcessoExecutavelModel? succes, AppError? error}) _processoExec;
  late SepararConsultaServices _separarConsultaServices;
  late ExpedicaoSepararConsultaModel? _separarConsulta;

  final _isLoad = false.obs;

  @override
  Future<void> onInit() async {
    await _onInit();

    super.onInit();
  }

  _onInit() async {
    _isLoad.value = true;
    _processoExec = await _controller.getProcessoExecutavel();

    if (_processoExec.error != null) {
      Get.offNamed(AppRouter.notfind);
      return;
    }

    _separarConsultaServices = SepararConsultaServices(
      codEmpresa: _processoExec.succes!.codEmpresa,
      codSepararEstoque: _processoExec.succes!.codOrigem,
    );

    _separarConsulta = await _separarConsultaServices.separarConsulta();
    if (_separarConsulta == null) {
      Get.offNamed(AppRouter.notfind);
      return;
    }

    _isLoad.value = false;
    nextPage();
  }

  bool get isLoad => _isLoad.value;
  AppError? get error => _processoExec.error;

  void nextPage() async {
    Get.find<ProcessoExecutavelModel>().update(_processoExec.succes!);
    Get.offNamed(AppRouter.separar, arguments: {
      'processoExecutavel': _processoExec.succes,
      'separarConsulta': _separarConsulta,
    });
  }
}
