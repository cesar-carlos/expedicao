import 'package:get/get.dart';

import 'package:app_expedicao/src/routes/app_router.dart';
import 'package:app_expedicao/src/model/error.message.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/service/usuario_service.dart';
import 'package:app_expedicao/src/model/expedicao_origem_model.dart';
import 'package:app_expedicao/src/service/separar_consultas_services.dart';
import 'package:app_expedicao/src/service/conferir_consultas_services.dart';
import 'package:app_expedicao/src/model/expedicao_conferir_consulta_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/service/processo_executavel_service.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/app/app_server_file_init.dart';
import 'package:app_expedicao/src/model/usuario_consulta.dart';
import 'package:app_expedicao/src/app/app_api_file_init.dart';

class SplashController extends GetxController {
  final _socketClient = Get.find<AppSocketConfig>();

  late ProcessoExecutavelModel? _processoExecutavel;
  late ExpedicaoSepararConsultaModel? _separarConsulta;
  late ExpedicaoConferirConsultaModel? _conferirConsulta;
  late UsuarioConsultaMoldel? _usuarioLogado;

  @override
  void onInit() {
    super.onInit();
    _loading();
  }

  Future<void> _loading() async {
    final existsfileConfApi = await _existsfileConfApi();
    if (!existsfileConfApi) {
      _leave(AppRouter.login);
      return;
    }

    final conectado = await _socketClient.ensureStarted();
    if (!conectado) {
      _leave(
        AppRouter.splashError,
        arguments: ErrorMessage(
          title: 'Erro de conexão',
          message: 'Não foi possível conectar ao servidor. Verifique a rede e o endereço da API.',
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

        _leave(AppRouter.splashError, arguments: errorMessage);
        return;
      }

      _putPermanent(_processoExecutavel!);
    }

    final usuarioFuture = UsuarioService.selectConsulta(
      _processoExecutavel!.codUsuario,
    );
    final databaseFuture = _existsfileConfDataBase();
    _usuarioLogado = await usuarioFuture;
    final existsfileConfDataBase = await databaseFuture;
    if (!existsfileConfDataBase || _processoExecutavel == null) {
      _leave(AppRouter.login);
      return;
    }

    if (_usuarioLogado == null) {
      final errorMessage = ErrorMessage(
        title: 'Erro',
        message: 'Usuario Logado não encontrado',
      );

      _leave(AppRouter.splashError, arguments: errorMessage);
      return;
    }

    _putPermanent<UsuarioConsultaMoldel>(_usuarioLogado!);

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

        _leave(AppRouter.splashError, arguments: errorMessage);
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

        _leave(AppRouter.splashError, arguments: errorMessage);
        return;
      }
    }

    nextPage();
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
    _putPermanent<ProcessoExecutavelModel>(_processoExecutavel!);

    //SEPARAR
    if (_processoExecutavel!.origem == ExpedicaoOrigemModel.separacao) {
      _leave(AppRouter.separar, arguments: _separarConsulta);
      return;
    }

    //CONFERENCIA
    if (_processoExecutavel!.origem == ExpedicaoOrigemModel.conferencia) {
      _leave(AppRouter.conferir, arguments: _conferirConsulta);
      return;
    }

    //NOT FOUND
    _leave(AppRouter.notfind);
  }

  void _leave(String route, {dynamic arguments}) {
    Get.offAllNamed(route, arguments: arguments);
  }

  void _putPermanent<T>(T instance) {
    if (Get.isRegistered<T>()) return;
    Get.put<T>(instance, permanent: true);
  }
}
