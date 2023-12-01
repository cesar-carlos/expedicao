import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_socket.config.dart';
import 'package:app_expedicao/src/service/separar_consultas_services.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_sever_dialog.widget.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/service/processo_executavel_service.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/routes/app_router.dart';

class SplashController extends GetxController {
  final _isLoad = false.obs;

  final _processoExecutavelService = ProcessoExecutavelService();
  final _socketClient = Get.find<AppSocketConfig>();

  late ProcessoExecutavelModel? _processoExecutavel;
  late SepararConsultaServices _separarConsultaServices;
  late ExpedicaoSepararConsultaModel? _separarConsulta;

  bool get isLoad => _isLoad.value;

  @override
  Future<void> onInit() async {
    super.onInit();

    await _loading();
    _litener();
  }

  _loading() async {
    _isLoad.value = true;
    await Future.delayed(const Duration(seconds: 1));

    _processoExecutavel = await _processoExecutavelService.executar();
    if (_processoExecutavel == null) {
      Get.offNamed(AppRouter.splashError, arguments: '0001');
      return;
    }

    _separarConsultaServices = SepararConsultaServices(
      codEmpresa: _processoExecutavel!.codEmpresa,
      codSepararEstoque: _processoExecutavel!.codOrigem,
    );

    _separarConsulta = await _separarConsultaServices.separar();
    if (_separarConsulta == null) {
      Get.offNamed(AppRouter.splashError, arguments: '0002');
      return;
    }

    _isLoad.value = false;
    nextPage();
  }

  _litener() {
    _socketClient.isConnect.listen((event) {
      if (event) _loading();

      LoadingSeverDialogWidget.show(
        context: Get.context!,
      );
    });
  }

  void nextPage() async {
    Get.put<ProcessoExecutavelModel>(_processoExecutavel!);
    Get.offNamed(AppRouter.separar, arguments: _separarConsulta);
  }
}
