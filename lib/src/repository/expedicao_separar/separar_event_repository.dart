import 'dart:convert';
import 'package:get/get.dart';

import 'package:app_expedicao/src/model/repository_event_lister_model.dart';
import 'package:app_expedicao/src/model/basic_event_model.dart';
import 'package:app_expedicao/src/app/app_socket.config.dart';

class SepararEventRepository {
  static SepararEventRepository? _instancia;
  final List<RepositoryEventListerModel> _liteners = [];

  final _appSocket = Get.find<AppSocketConfig>();

  SepararEventRepository._() {
    _onInsert();
    _onUpdate();
    _onDelete();
  }

  static SepararEventRepository get instancia {
    _instancia ??= SepararEventRepository._();
    return _instancia!;
  }

  addListener(RepositoryEventListerModel listerner) {
    _liteners.add(listerner);
  }

  removeListener(RepositoryEventListerModel listerner) {
    _liteners.remove(listerner);
  }

  void _onInsert() {
    const event = 'separar.insert.listen';
    _appSocket.socket.on(event, (data) {
      _liteners
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
    const event = 'separar.update.listen';
    _appSocket.socket.on(event, (data) {
      _liteners
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
    const event = 'separar.delete.listen';
    _appSocket.socket.on(event, (data) {
      _liteners
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
