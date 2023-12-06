import 'package:app_expedicao/src/repository/expedicao_separar/separar_event_repository.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:app_expedicao/src/model/expedicao_separar_model.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_services.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_situacao_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_item_consulta_model.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog.widget.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_sever_dialog.widget.dart';
import 'package:app_expedicao/src/pages/separar_carrinhos/separar_carrinhos_controller.dart';
import 'package:app_expedicao/src/pages/carrinho/widget/adicionar_carrinho_dialog_widget.dart';
import 'package:app_expedicao/src/repository/expedicao_separar_item/separar_item_event_repository.dart';
import 'package:app_expedicao/src/pages/common/widget/confirmation_dialog_message_widget.dart';
import 'package:app_expedicao/src/service/carrinho_percurso_estagio_adicionar_service.dart';
import 'package:app_expedicao/src/pages/separar/grid/separar_grid_controller.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_percurso_model.dart';
import 'package:app_expedicao/src/model/expedicao_separar_consulta_model.dart';
import 'package:app_expedicao/src/service/separar_consultas_services.dart';
import 'package:app_expedicao/src/service/separar_finalizar_service.dart';
import 'package:app_expedicao/src/model/processo_executavel_model.dart';
import 'package:app_expedicao/src/model/expedicao_carrinho_model.dart';
import 'package:app_expedicao/src/model/expedicao_situacao_model.dart';
import 'package:app_expedicao/src/service/separar_services.dart';
import 'package:app_expedicao/src/app/app_socket.config.dart';

class SepararController extends GetxController {
  bool _iniciada = false;

  late AppSocketConfig _socketClient;
  late String _expedicaoSituacaoModel;
  late SepararConsultaServices _separarServices;
  late SepararGridController _separarGridController;
  late SepararCarrinhosController _separarCarrinhosController;
  late ExpedicaoSepararConsultaModel _separarConsulta;
  late ProcessoExecutavelModel _processoExecutavel;

  ExpedicaoCarrinhoPercursoModel? _carrinhoPercurso;

  ExpedicaoSepararConsultaModel get separarConsulta => _separarConsulta;

  bool get iniciada {
    if (_carrinhoPercurso == null) {
      _iniciada = false;
      return _iniciada;
    } else {
      _iniciada = true;
      return _iniciada;
    }
  }

  String get expedicaoSituacaoModel => _expedicaoSituacaoModel;
  String get expedicaoSituacaoDisplay =>
      ExpedicaoSituacaoModel.situacao[_expedicaoSituacaoModel] ?? '';

  @override
  onInit() async {
    super.onInit();

    _socketClient = Get.find<AppSocketConfig>();
    _processoExecutavel = Get.find<ProcessoExecutavelModel>();
    _separarConsulta = Get.find<ExpedicaoSepararConsultaModel>();
    _separarCarrinhosController = Get.find<SepararCarrinhosController>();
    _separarGridController = Get.find<SepararGridController>();
    _expedicaoSituacaoModel = _separarConsulta.situacao;

    _separarServices = SepararConsultaServices(
      codEmpresa: _processoExecutavel.codEmpresa,
      codSepararEstoque: _processoExecutavel.codOrigem,
    );
  }

  @override
  onReady() async {
    super.onReady();
    await _fillGridSepararItens();
    await _fillCarrinhoPercurso();

    _liteners();
  }

  Future<void> _fillGridSepararItens() async {
    final separarItens = await _separarServices.itensSaparar();
    _separarGridController.addAllGrid(separarItens);
    _separarGridController.update();
  }

  Future<void> _fillCarrinhoPercurso() async {
    final carrinhoPercursos = await CarrinhoPercursoServices().select(
      ''' CodEmpresa = ${_processoExecutavel.codEmpresa} 
        AND Origem = '${_processoExecutavel.origem}' 
        AND CodOrigem = ${_processoExecutavel.codOrigem}
        
        ''',
    );

    if (carrinhoPercursos.isNotEmpty) {
      _carrinhoPercurso = carrinhoPercursos.first;
    }
  }

  Future<void> iniciarSeparacao() async {
    _iniciada = !_iniciada;
    if (_carrinhoPercurso == null) {
      await _fillCarrinhoPercurso();
    }

    final separar = ExpedicaoSepararModel.fromConsulta(_separarConsulta);
    final separarServices = SepararServices(separar: separar);
    await separarServices.iniciar();
    _expedicaoSituacaoModel = ExpedicaoSituacaoModel.emAndamento;
    _separarConsulta.situacao = ExpedicaoSituacaoModel.emAndamento;
    update();
  }

  Future<void> pausarSeparacao() async {
    await ConfirmationDialogMessageWidget.show(
      context: Get.context!,
      message: 'Não implementado!',
      detail: 'Não é possível pausar, funcionalidade não foi implementada.',
    );
  }

  Future<void> adicionarCarrinho() async {
    if (_expedicaoSituacaoModel == ExpedicaoSituacaoModel.finalizada) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Separação já finalizada!',
        detail: 'Separação já finalizada, não é possível finalizar novamente.',
      );

      return;
    }

    final dialog = AdicionarCarrinhoDialogWidget();
    final carrinhoConsulta = await dialog.show();

    if (carrinhoConsulta != null) {
      await iniciarSeparacao();
      await _fillCarrinhoPercurso();

      final carrinho = ExpedicaoCarrinhoModel(
        codEmpresa: carrinhoConsulta.codEmpresa,
        codCarrinho: carrinhoConsulta.codCarrinho,
        descricao: carrinhoConsulta.descricaoCarrinho,
        ativo: carrinhoConsulta.ativo,
        codigoBarras: carrinhoConsulta.codigoBarras,
        situacao: ExpedicaoCarrinhoSituacaoModel.emSeparacao,
      );

      final percursoEstagio = await CarrinhoPercursoEstagioAdicionarService(
        carrinho: carrinho,
        carrinhoPercurso: _carrinhoPercurso!,
      ).execute();

      if (percursoEstagio != null) {
        final percursoEstagioConsulta =
            await _separarServices.carrinhosPercurso()
              ..where((el) => el.item == percursoEstagio.item).toList();

        _separarCarrinhosController.addCarrinho(percursoEstagioConsulta.last);
      }
    }
  }

  Future<void> finalizarSeparacao() async {
    final isComplete = await _separarServices.isComplete();
    final existsOpenCart = await _separarServices.existsOpenCart();

    if (_expedicaoSituacaoModel == ExpedicaoSituacaoModel.finalizada) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Separação já finalizada!',
        detail: 'Separação já finalizada, não é possível finalizar novamente.',
      );

      return;
    }

    if (!isComplete) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Separação não finalizada!',
        detail: 'Separação não finalizada, existem itens não separados.',
      );

      return;
    }

    if (existsOpenCart) {
      await ConfirmationDialogMessageWidget.show(
        context: Get.context!,
        message: 'Separação não finalizada!',
        detail: 'Separação não finalizada, existem carrinhos em aberto.',
      );

      return;
    }

    final bool? confirmation = await ConfirmationDialogWidget.show(
      context: Get.context!,
      message: 'Deseja realmente finalizar?',
      detail: 'Não será possível adicionar ou alterar mais os carrinhos.',
    );

    if (confirmation != null && confirmation) {
      await SepararFinalizarService(
        codEmpresa: _separarConsulta.codEmpresa,
        codSepararEstoque: _separarConsulta.codSepararEstoque,
      ).execute();

      _expedicaoSituacaoModel = ExpedicaoSituacaoModel.finalizada;
      _separarConsulta.situacao = ExpedicaoSituacaoModel.finalizada;
      update();
    }
  }

  _liteners() {
    const uuid = Uuid();
    final separarEvent = SepararEventRepository.instancia;
    final carrinhoPercursoEvent = SepararItemEventRepository.instancia;

    _socketClient.isConnect.listen((event) {
      if (event) return;
      LoadingSeverDialogWidget.show(
        context: Get.context!,
      );
    });

    carrinhoPercursoEvent.addListener(
      RepositoryEventListenerModel(
        id: uuid.v4(),
        event: Event.update,
        callback: (data) async {
          for (var el in data.mutation) {
            final item = ExpedicaoSepararItemConsultaModel.fromJson(el);
            _separarGridController.updateGrid(item);
            _separarGridController.update();
          }
        },
      ),
    );

    separarEvent.addListener(
      RepositoryEventListenerModel(
        id: uuid.v4(),
        event: Event.update,
        callback: (data) async {
          for (var el in data.mutation) {
            final item = ExpedicaoSepararModel.fromJson(el);
            _expedicaoSituacaoModel = item.situacao;
            _separarConsulta.situacao = item.situacao;
            update();
          }
        },
      ),
    );
  }
}
