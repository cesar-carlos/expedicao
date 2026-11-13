import 'dart:async';

import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/pages/common/widget/loading_sever_dialog_widget.dart';

class FooterPageController extends GetxController {
  static const _reconnectDialogDelay = Duration(milliseconds: 800);

  final _socket = Get.find<AppSocketConfig>();
  Worker? _connectionWorker;
  Timer? _disconnectDebounce;
  bool _hadSuccessfulConnection = false;
  bool _showingReconnectDialog = false;

  bool get isConnected => _socket.isConnect.value;

  @override
  void onInit() {
    super.onInit();
    _hadSuccessfulConnection = _socket.isConnect.value;
    _connectionWorker = ever(_socket.isConnect, _onConnectionChanged);
  }

  void _onConnectionChanged(bool connected) {
    update();
    if (connected) {
      _hadSuccessfulConnection = true;
      _disconnectDebounce?.cancel();
      _disconnectDebounce = null;
      return;
    }
    if (!_hadSuccessfulConnection || _showingReconnectDialog) return;
    if (_socket.sessionEndedByServer.value) return;
    if (_disconnectDebounce?.isActive ?? false) return;

    _disconnectDebounce = Timer(_reconnectDialogDelay, _showReconnectDialog);
  }

  void _showReconnectDialog() {
    if (_socket.isConnect.value || _showingReconnectDialog) return;
    if (_socket.sessionEndedByServer.value) return;

    final context = Get.context;
    if (context == null) return;

    _showingReconnectDialog = true;
    LoadingSeverDialogWidget.show(
      canCloseWindow: false,
      context: context,
    ).whenComplete(() {
      _showingReconnectDialog = false;
    });
  }

  @override
  void onClose() {
    _disconnectDebounce?.cancel();
    _connectionWorker?.dispose();
    super.onClose();
  }
}
