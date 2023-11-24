import 'dart:convert';
import 'package:get/get.dart';

import 'package:app_expedicao/src/model/repository_event_lister_model.dart';
import 'package:app_expedicao/src/model/basic_event_model.dart';
import 'package:app_expedicao/src/app/app_socket.config.dart';

class CarrinhoPercursoEventRepository {
  static CarrinhoPercursoEventRepository? _instancia;
  final List<RepositoryEventListerModel> _liteners = [];

  final _appSocket = Get.find<AppSocketConfig>();

  CarrinhoPercursoEventRepository._() {
    _onInsert();
    _onUpdate();
    _onDelete();
  }

  static CarrinhoPercursoEventRepository get instancia {
    _instancia ??= CarrinhoPercursoEventRepository._();
    return _instancia!;
  }

  addListener(RepositoryEventListerModel listerner) {
    _liteners.add(listerner);
  }

  removeListener(RepositoryEventListerModel listerner) {
    _liteners.remove(listerner);
  }

  void _onInsert() {
    const event = 'carrinho.percurso.estagio.insert.listen';
    _appSocket.socket.on(event, (data) {
      _liteners
          .where((element) => element.event == Event.insert)
          .forEach((element) {
        final basicEvent = _convert(data);
        if (basicEvent.session == _appSocket.socket.id) return;
        element.callback(basicEvent);
      });
    });
  }

  void _onUpdate() {
    const event = 'carrinho.percurso.estagio.update.listen';
    _appSocket.socket.on(event, (data) {
      _liteners
          .where((element) => element.event == Event.update)
          .forEach((element) {
        final basicEvent = _convert(data);
        if (basicEvent.session == _appSocket.socket.id) return;
        element.callback(basicEvent);
      });
    });
  }

  void _onDelete() {
    const event = 'carrinho.percurso.estagio.delete.listen';
    _appSocket.socket.on(event, (data) {
      _liteners
          .where((element) => element.event == Event.delete)
          .forEach((element) {
        final basicEvent = _convert(data);
        if (basicEvent.session == _appSocket.socket.id) return;
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
