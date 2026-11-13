import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_expedicao/src/app/app_color.dart';
import 'package:app_expedicao/src/app/app_dialog_close.dart';
import 'package:app_expedicao/src/app/app_event_state.dart';
import 'package:app_expedicao/src/app/app_raw_keyboard.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/model/servidor_emergencia_aviso_model.dart';
import 'package:app_expedicao/src/pages/common/form_element/button_form_element.dart';

class SessaoEncerradaDialogWidget {
  static bool _isShowing = false;

  static Future<void> show({
    required BuildContext context,
    required ServidorEmergenciaAvisoModel aviso,
  }) {
    if (_isShowing) return Future.value();
    _isShowing = true;

    if (Get.isRegistered<AppEventState>()) {
      Get.find<AppEventState>().canCloseWindow = true;
    }

    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (_) => _SessaoEncerradaDialog(aviso: aviso),
    ).whenComplete(() {
      _isShowing = false;
    });
  }
}

class _SessaoEncerradaDialog extends StatefulWidget {
  final ServidorEmergenciaAvisoModel aviso;

  const _SessaoEncerradaDialog({required this.aviso});

  @override
  State<_SessaoEncerradaDialog> createState() => _SessaoEncerradaDialogState();
}

class _SessaoEncerradaDialogState extends State<_SessaoEncerradaDialog> {
  final _formFocusNode = FocusNode();
  final _reconnectFocusNode = FocusNode();
  final _closeGuard = DialogCloseGuard();
  Worker? _connectionWorker;
  bool _reconnecting = false;
  bool _closed = false;

  AppSocketConfig get _socket => Get.find<AppSocketConfig>();

  bool get _canReconnect => !_socket.isConnect.value && !_reconnecting;

  @override
  void initState() {
    super.initState();
    _connectionWorker = ever(_socket.isConnect, (bool connected) {
      if (connected) _close();
    });
    if (_socket.isConnect.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _close());
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _reconnectFocusNode.requestFocus();
      });
    }
  }

  Future<void> _reconnect() async {
    if (!_canReconnect) return;
    setState(() => _reconnecting = true);
    try {
      await _socket.reconnectAfterServerEnd();
    } finally {
      if (mounted && !_socket.isConnect.value) {
        setState(() => _reconnecting = false);
      }
    }
  }

  void _close() {
    if (_closed) return;
    _closed = true;
    _connectionWorker?.dispose();
    _connectionWorker = null;
    _closeGuard.close(context: context);
  }

  KeyEventResult _handleKeyEvent(AppRawKeyEvent event) {
    if (!isRawKeyDown(event)) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.f12 ||
        event.logicalKey == LogicalKeyboardKey.enter) {
      _reconnect();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _connectionWorker?.dispose();
    _formFocusNode.dispose();
    _reconnectFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mensagem = widget.aviso.mensagem.trim();

    return PopScope(
      canPop: false,
      child: AppKeyboardListener(
        focusNode: _formFocusNode,
        onKey: _handleKeyEvent,
        child: Dialog(
          child: Container(
            width: 420,
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: AppColor.foregroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 15, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Servidor encerrou a sessão',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        mensagem.isEmpty
                            ? 'A conexão foi encerrada pelo servidor. Reconecte para continuar.'
                            : mensagem,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_reconnecting)
                        const Padding(
                          padding: EdgeInsets.only(right: 12, bottom: 10),
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ButtonFormElement(
                        name: 'Reconectar',
                        padding: const EdgeInsets.only(right: 5, bottom: 10),
                        focusNode: _reconnectFocusNode,
                        onPressed: _canReconnect ? _reconnect : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
