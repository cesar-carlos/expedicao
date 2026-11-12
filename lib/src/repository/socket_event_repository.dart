import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_socket_config.dart';
import 'package:app_expedicao/src/contract/event_contract.dart';
import 'package:app_expedicao/src/model/basic_event_model.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';

/// Base dos repositórios de listen: um parse por pacote e filtro de sessão.
class SocketEventRepository implements EventContract {
  final List<RepositoryEventListenerModel> _listeners = [];
  final AppSocketConfig _socket = Get.find<AppSocketConfig>();

  @override
  List<RepositoryEventListenerModel> get listener => _listeners;

  void bind(String channel, Event event) {
    _socket.listen(channel, (data) {
      dispatch(
        listeners: _listeners,
        event: event,
        data: data,
        sessionId: _socket.sessionId,
      );
    });
  }

  /// Decodifica uma vez e notifica só os listeners do [event].
  static void dispatch({
    required List<RepositoryEventListenerModel> listeners,
    required Event event,
    required dynamic data,
    required String? sessionId,
  }) {
    if (listeners.isEmpty) return;

    final basicEvent = BasicEventModel.parse(data);
    for (final listener in List<RepositoryEventListenerModel>.of(listeners)) {
      if (listener.event != event) continue;
      if (basicEvent.session == sessionId && !listener.allEvent) continue;
      listener.callback(basicEvent);
    }
  }

  @override
  void addListener(RepositoryEventListenerModel listerner) {
    _listeners.add(listerner);
  }

  @override
  void removeListener(RepositoryEventListenerModel listerner) {
    _listeners.removeWhere((element) => element.id == listerner.id);
  }

  @override
  void removeListeners(List<RepositoryEventListenerModel> listerners) {
    final ids = listerners.map((element) => element.id).toSet();
    if (ids.isEmpty) return;
    _listeners.removeWhere((element) => ids.contains(element.id));
  }

  @override
  void removeListenerById(String id) {
    _listeners.removeWhere((element) => element.id == id);
  }

  @override
  void removeAllListener() {
    _listeners.clear();
  }
}
