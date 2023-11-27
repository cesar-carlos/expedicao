import 'package:get/get.dart';

import 'package:app_expedicao/src/service/separar_consulta_services.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/service/processo_executavel_service.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/routes/app_router.dart';

class SplashController extends GetxController {
  final _processoExecutavelService = ProcessoExecutavelService();

  late ProcessoExecutavelModel? _processoExecutavel;
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
    //delay socket connection
    await Future.delayed(const Duration(seconds: 1));

    _processoExecutavel = await _processoExecutavelService.executar();

    if (_processoExecutavel == null) {
      const arguments = '''
        Não foi possível executar o processo.
          1) Verifique se o servidor está online.
          2) Verifique se o banco de dados está online.
          3) Verifique se o banco de dados está configurado corretamente.
      ''';

      Get.offNamed(AppRouter.notfind, arguments: arguments);
      return;
    }

    _separarConsultaServices = SepararConsultaServices(
      codEmpresa: _processoExecutavel!.codEmpresa,
      codSepararEstoque: _processoExecutavel!.codOrigem,
    );

    _separarConsulta = await _separarConsultaServices.separarConsulta();
    if (_separarConsulta == null) {
      const arguments = '''
        Não foi possível localizar itens da separação.
          1) Verifique se o servidor está online.
          2) Verifique se o banco de dados está online.
          3) Verifique se o banco de dados está configurado corretamente.
      ''';

      Get.offNamed(AppRouter.notfind, arguments: arguments);
      return;
    }

    _isLoad.value = false;
    nextPage();
  }

  bool get isLoad => _isLoad.value;

  void nextPage() async {
    Get.put<ProcessoExecutavelModel>(_processoExecutavel!);
    Get.offNamed(AppRouter.separar, arguments: {
      'processoExecutavel': _processoExecutavel,
      'separarConsulta': _separarConsulta,
    });
  }
}
