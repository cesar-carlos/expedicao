import 'dart:async';

import 'package:get/get.dart';

import 'package:app_expedicao/src/routes/app_router.dart';
import 'package:app_expedicao/src/model/error.message.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/service/usuario_service.dart';
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/service/separar_consultas_services.dart';
import 'package:app_expedicao/src/service/conferir_consultas_services.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_sever_dialog_widget.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/service/processo_executavel_service.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/app/app_server_file_init.dart';
import 'package:app_expedicao/src/model/usuario_consulta.dart';
import 'package:app_expedicao/src/app/app_api_file_init.dart';

class SplashController extends GetxController {
  final _socketClient = Get.find<AppSocketConfig>();
  StreamSubscription<bool>? _socketWorker;
  bool _showingReconnectDialog = false;

  late ProcessoExecutavelModel? _processoExecutavel;
  late ExpedicaoSepararConsultaModel? _separarConsulta;
  late ExpedicaoConferirConsultaModel? _conferirConsulta;
  late UsuarioConsultaMoldel? _usuarioLogado;

  @override
  void onInit() {
    super.onInit();
    _litener();
    _loading();
  }

  @override
  void onClose() {
    _socketWorker?.cancel();
    super.onClose();
  }

  Future<void> _loading() async {
    final existsfileConfApi = await _existsfileConfApi();
    if (!existsfileConfApi) {
      Get.offNamed(AppRouter.login);
      return;
    }

    final conectado = await _socketClient.waitUntilConnected();
    if (!conectado) {
      Get.offNamed(
        AppRouter.splashError,
        arguments: ErrorMessage(
          title: 'Erro',
          message: 'verifique a conexão com o servidor',
        ),
      );
      return;
    }

    try {
      _processoExecutavel = Get.find<ProcessoExecutavelModel>();
    } catch (_) {
      _processoExecutavel = await ProcessoExecutavelService().executar();

      if (_processoExecutavel == null) {
        final errorMessage = ErrorMessage(
          title: 'Erro',
          message: 'verifique a conexão com o servidor',
        );

        Get.offNamed(AppRouter.splashError, arguments: errorMessage);
        return;
      }

      Get.put(_processoExecutavel!);
    }

    final usuarioFuture =
        UsuarioService.selectConsulta(_processoExecutavel!.codUsuario);
    final databaseFuture = _existsfileConfDataBase();
    _usuarioLogado = await usuarioFuture;
    final existsfileConfDataBase = await databaseFuture;
    if (!existsfileConfDataBase || _processoExecutavel == null) {
      Get.offNamed(AppRouter.login);
      return;
    }

    if (_usuarioLogado == null) {
      final errorMessage = ErrorMessage(
        title: 'Erro',
        message: 'Usuario Logado não encontrado',
      );

      Get.offNamed(AppRouter.splashError, arguments: errorMessage);
      return;
    }

    Get.put<UsuarioConsultaMoldel>(_usuarioLogado!);

    if (_processoExecutavel!.origem == ExpedicaoOrigemModel.separacao) {
      final separarConsultaServices = SepararConsultaServices(
        codEmpresa: _processoExecutavel!.codEmpresa,
        codSepararEstoque: _processoExecutavel!.codOrigem,
      );

      _separarConsulta = await separarConsultaServices.separar();

      if (_separarConsulta == null) {
        final errorMessage = ErrorMessage(
          title: 'Erro',
          message: 'Separar estoque não encontrado',
        );

        Get.offNamed(AppRouter.splashError, arguments: errorMessage);
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
        final errorMessage = ErrorMessage(
          title: 'Erro',
          message: 'Conferir estoque não encontrado',
        );

        Get.offNamed(AppRouter.splashError, arguments: errorMessage);
        return;
      }
    }

    nextPage();
  }

  void _litener() {
    _socketWorker = _socketClient.isConnect.listen((connected) {
      if (connected || _showingReconnectDialog) return;

      final context = Get.context;
      if (context == null) return;

      _showingReconnectDialog = true;
      LoadingSeverDialogWidget.show(
        canCloseWindow: false,
        context: context,
      ).whenComplete(() {
        _showingReconnectDialog = false;
      });
    });
  }

  Future<bool> _existsfileConfDataBase() async {
    final hasConfg = await AppServerFileInit.hasConfg();
    return hasConfg;
  }

  Future<bool> _existsfileConfApi() async {
    final hasConfg = await AppApiFileInit.hasConfg();
    return hasConfg;
  }

  void nextPage() async {
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
