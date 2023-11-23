import 'dart:convert';
import 'package:get/get.dart';

import 'package:app_expedicao/src/model/repository_event_lister_model.dart';
import 'package:app_expedicao/src/model/basic_event_model.dart';
import 'package:app_expedicao/src/app/app_socket.config.dart';

class SepararItemEventRepository {
  static SepararItemEventRepository? _instancia;
  final List<RepositoryEventListerModel> _liteners = [];

  final _appSocket = Get.find<AppSocketConfig>();

  SepararItemEventRepository._() {
    _onInsert();
    _onUpdate();
    _onDelete();
  }

  static SepararItemEventRepository get instancia {
    _instancia ??= SepararItemEventRepository._();
    return _instancia!;
  }

  addListener(RepositoryEventListerModel listerner) {
    _liteners.add(listerner);
  }

  removeListener(RepositoryEventListerModel listerner) {
    _liteners.remove(listerner);
  }

  void _onInsert() {
    const event = 'separar.item.insert.listen';
    _appSocket.socket.on(event, (data) {
      _liteners
          .where((element) => element.event == Event.insert)
          .forEach((element) {
        element.callback(_convert(data));
      });
    });
  }

  void _onUpdate() {
    const event = 'separar.item.update.listen';
    _appSocket.socket.on(event, (data) {
      _liteners
          .where((element) => element.event == Event.update)
          .forEach((element) {
        element.callback(_convert(data));
      });
    });
  }

  void _onDelete() {
    const event = 'separar.item.delete.listen';
    _appSocket.socket.on(event, (data) {
      _liteners
          .where((element) => element.event == Event.delete)
          .forEach((element) {
        element.callback(_convert(data));
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
