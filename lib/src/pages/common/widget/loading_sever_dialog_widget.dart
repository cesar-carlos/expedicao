import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:app_expedicao/src/app/app_event_state.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class LoadingSeverDialogWidget {
  static bool _isShowing = false;

  static Future<void> show({
    required bool canCloseWindow,
    required BuildContext context,
  }) {
    if (_isShowing) return Future.value();
    _isShowing = true;

    Get.find<AppEventState>().canCloseWindow = canCloseWindow;

    return showDialog<void>(
      barrierDismissible: false,
      barrierColor: Colors.white.withValues(alpha: 0.7),
      context: context,
      builder: (_) => const _LoadingServerDialog(),
    ).whenComplete(() {
      _isShowing = false;
    });
  }
}

class _LoadingServerDialog extends StatefulWidget {
  const _LoadingServerDialog();

  @override
  State<_LoadingServerDialog> createState() => _LoadingServerDialogState();
}

class _LoadingServerDialogState extends State<_LoadingServerDialog> {
  Worker? _connectionWorker;
  bool _closed = false;

  @override
  void initState() {
    super.initState();
    final socket = Get.find<AppSocketConfig>();

    if (socket.isConnect.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _close());
      return;
    }

    _connectionWorker = ever(socket.isConnect, (bool connected) {
      if (connected) _close();
    });
  }

  void _close() {
    if (_closed) return;
    _closed = true;
    _connectionWorker?.dispose();
    _connectionWorker = null;

    if (Get.isRegistered<AppEventState>()) {
      Get.find<AppEventState>().canCloseWindow = true;
    }

    if (!mounted) return;

    final route = ModalRoute.of(context);
    if (route == null || !route.isActive) return;

    final navigator = Navigator.of(context);
    if (route.isCurrent) {
      navigator.pop();
    } else {
      navigator.removeRoute(route);
    }
  }

  @override
  void dispose() {
    _connectionWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: Center(
        child: SizedBox(
          width: 800,
          height: 300,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Conectando ao servidor...'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
