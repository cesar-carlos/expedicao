import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/app/app_socket_listen_log.dart';
import 'package:app_expedicao/src/model/basic_event_model.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/model/servidor_emergencia_aviso_model.dart';
import 'package:app_expedicao/src/pages/common/message_dialog/message_dialog_view.dart';
import 'package:app_expedicao/src/pages/common/widget/sessao_encerrada_dialog_widget.dart';
import 'package:app_expedicao/src/repository/servidor_emergencia/servidor_emergencia_event_repository.dart';

/// Listener global de `servidor.emergencia.listen`. Registra na conexão,
/// não no dispose da tela de separar/conferir. `allEvent: true` — o canal
/// não manda `Session`.
class ServidorEmergenciaService extends GetxController {
  static const _listenerId = 'servidor-emergencia-global';

  final AppSocketConfig _socket = Get.find<AppSocketConfig>();
  Worker? _sessionEndedWorker;
  ServidorEmergenciaAvisoModel? _lastAviso;
  bool _showingAviso = false;
  bool _showingSessaoEncerrada = false;

  @override
  void onInit() {
    super.onInit();
    _bindListener();
    _sessionEndedWorker = ever(_socket.sessionEndedByServer, (ended) {
      if (ended) _showSessaoEncerrada();
    });
  }

  void _bindListener() {
    final repo = ServidorEmergenciaEventRepository.instancia;
    repo.removeListenerById(_listenerId);
    repo.addListener(
      RepositoryEventListenerModel(
        id: _listenerId,
        event: Event.emergencia,
        allEvent: true,
        callback: _onEmergencia,
      ),
    );
  }

  void _onEmergencia(BasicEventModel event) {
    final aviso = ServidorEmergenciaAvisoModel.fromMutation(event.mutation);
    if (aviso == null) return;

    _lastAviso = aviso;
    AppSocketListenLog.applied(
      origem: 'ServidorEmergenciaService',
      situacao: aviso.codigo,
      extra: 'acao=${aviso.acao} prazoMs=${aviso.prazoMs}',
    );

    if (aviso.vaiDesconectar) {
      _socket.pauseForServerDisconnect();
    }

    final desconectarImediato =
        aviso.vaiDesconectar && aviso.prazoMs <= 0;
    if (desconectarImediato) {
      if (_socket.sessionEndedByServer.value) {
        _showSessaoEncerrada();
      }
      return;
    }

    _showAviso(aviso);
  }

  void _showAviso(ServidorEmergenciaAvisoModel aviso) {
    if (aviso.mensagem.trim().isEmpty) return;
    if (aviso.vaiDesconectar && _socket.sessionEndedByServer.value) {
      _showSessaoEncerrada();
      return;
    }

    _present(() async {
      if (_showingAviso) return;
      final context = Get.context;
      if (context == null || !context.mounted) return;

      _showingAviso = true;
      try {
        await MessageDialogView.show(
          context: context,
          message: aviso.titulo,
          detail: aviso.detalhe,
          canCloseWindow: true,
        );
      } finally {
        _showingAviso = false;
        if (_socket.sessionEndedByServer.value) {
          _showSessaoEncerrada();
        }
      }
    });
  }

  void _showSessaoEncerrada() {
    if (_showingAviso || _showingSessaoEncerrada) return;
    if (!_socket.sessionEndedByServer.value) return;

    _present(() async {
      if (_showingSessaoEncerrada) return;
      if (!_socket.sessionEndedByServer.value) return;
      final context = Get.context;
      if (context == null || !context.mounted) return;

      _showingSessaoEncerrada = true;
      try {
        await SessaoEncerradaDialogWidget.show(
          context: context,
          aviso: _lastAviso ??
              const ServidorEmergenciaAvisoModel(
                nivel: 'desconectar',
                codigo: 'SERVIDOR_DESCONECTAR',
                mensagem: '',
                acao: 'desconectar',
                prazoMs: 0,
              ),
        );
      } finally {
        _showingSessaoEncerrada = false;
      }
    });
  }

  void _present(VoidCallback action) {
    WidgetsBinding.instance.addPostFrameCallback((_) => action());
  }

  @override
  void onClose() {
    _sessionEndedWorker?.dispose();
    ServidorEmergenciaEventRepository.instancia.removeListenerById(
      _listenerId,
    );
    super.onClose();
  }
}
