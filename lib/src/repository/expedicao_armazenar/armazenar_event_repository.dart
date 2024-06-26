import 'dart:convert';
import 'package:get/get.dart';

import 'package:app_expedicao/src/contract/event_contract.dart';
import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/model/basic_event_model.dart';
import 'package:app_expedicao/src/app/app_socket_config.dart';

class ArmazenarEventRepository implements EventContract {
  static ArmazenarEventRepository? _instancia;
  final List<RepositoryEventListenerModel> _listener = [];

  @override
  List<RepositoryEventListenerModel> get listener => _listener;

  final _appSocket = Get.find<AppSocketConfig>();

  ArmazenarEventRepository._() {
    _onInsert();
    _onUpdate();
    _onDelete();
  }

  static ArmazenarEventRepository get instancia {
    _instancia ??= ArmazenarEventRepository._();
    return _instancia!;
  }

  @override
  addListener(RepositoryEventListenerModel listerner) {
    _listener.add(listerner);
  }

  @override
  void removeListener(RepositoryEventListenerModel listerner) {
    _listener.removeWhere((element) => element.id == listerner.id);
  }

  @override
  void removeListeners(List<RepositoryEventListenerModel> listerners) {
    _listener.removeWhere((element) => listerners.contains(element));
  }

  @override
  void removeListenerById(String id) {
    listener.removeWhere((el) => el.id == id);
  }

  @override
  void removeAllListener() {
    _listener.clear();
  }

  void _onInsert() {
    const event = 'armazenar.insert.listen';
    _appSocket.socket.on(event, (data) {
      _listener
          .where((element) => element.event == Event.insert)
          .forEach((element) {
        final basicEvent = _convert(data);

        if (basicEvent.session == _appSocket.socket.id && !element.allEvent) {
          return;
        }

        element.callback(basicEvent);
      });
    });
  }

  void _onUpdate() {
    const event = 'armazenar.update.listen';
    _appSocket.socket.on(event, (data) {
      _listener
          .where((element) => element.event == Event.update)
          .forEach((element) {
        final basicEvent = _convert(data);

        if (basicEvent.session == _appSocket.socket.id && !element.allEvent) {
          return;
        }

        element.callback(basicEvent);
      });
    });
  }

  void _onDelete() {
    const event = 'armazenar.delete.listen';
    _appSocket.socket.on(event, (data) {
      _listener
          .where((element) => element.event == Event.delete)
          .forEach((element) {
        final basicEvent = _convert(data);

        if (basicEvent.session == _appSocket.socket.id && !element.allEvent) {
          return;
        }

        element.callback(basicEvent);
      });
    });
  }

  BasicEventModel _convert(String data) {
    try {
      var deconde = jsonDecode(data);
      return BasicEventModel.fromJson(deconde);
    } catch (e) {
      return BasicEventModel.empty();
    }
  }
}
