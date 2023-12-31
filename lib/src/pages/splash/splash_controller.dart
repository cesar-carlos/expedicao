import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_socket.config.dart';
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/service/separar_consultas_services.dart';
import 'package:app_expedicao/src/service/conferir_consultas_services.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_consulta_model.dart';
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
  late ExpedicaoSepararConsultaModel? _separarConsulta;
  late ExpedicaoConferirConsultaModel? _conferirConsulta;

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

    //SEPARAR
    if (_processoExecutavel!.origem == ExpedicaoOrigemModel.separacao) {
      final separarConsultaServices = SepararConsultaServices(
        codEmpresa: _processoExecutavel!.codEmpresa,
        codSepararEstoque: _processoExecutavel!.codOrigem,
      );

      _separarConsulta = await separarConsultaServices.separar();
      if (_separarConsulta == null) {
        Get.offNamed(AppRouter.splashError, arguments: '0002');

        return;
      }
    }

    //CONFERENCIA
    if (_processoExecutavel!.origem == ExpedicaoOrigemModel.conferencia) {
      final conferirConsultaServices = ConferirConsultaServices(
        codEmpresa: _processoExecutavel!.codEmpresa,
        codConferir: _processoExecutavel!.codOrigem,
      );

      _conferirConsulta = await conferirConsultaServices.conferir();
      if (_conferirConsulta == null) {
        Get.offNamed(AppRouter.splashError, arguments: '0002');
        return;
      }
    }

    _isLoad.value = false;
    nextPage();
  }

  _litener() {
    _socketClient.isConnect.listen(
      (event) {
        if (event) _loading();

        LoadingSeverDialogWidget.show(
          context: Get.context!,
        );
      },
    );
  }

  void nextPage() async {
    //INJECT PROCESSO EXECUTAVEL
    Get.put<ProcessoExecutavelModel>(_processoExecutavel!);

    //SEPARAR
    if (_processoExecutavel!.origem == ExpedicaoOrigemModel.separacao) {
      Get.offNamed(AppRouter.separar, arguments: _separarConsulta);
      return;
    }

    //CONFERENCIA
    if (_processoExecutavel!.origem == ExpedicaoOrigemModel.conferencia) {
      Get.offNamed(AppRouter.conferir, arguments: _conferirConsulta);
      return;
    }

    //NOT FOUND
    Get.offNamed(AppRouter.notfind);
  }
}
