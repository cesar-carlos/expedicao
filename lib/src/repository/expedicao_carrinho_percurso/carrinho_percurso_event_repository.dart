import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_socket.config.dart';
import 'package:app_expedicao/src/model/repository_event_lister_model.dart';

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

  addListener<T>(RepositoryEventListerModel<T> listerner) {
    _liteners.add(listerner);
  }

  removeListener<T>(RepositoryEventListerModel<T> listerner) {
    _liteners.remove(listerner);
  }

  void _onInsert() {
    const event = 'broadcast.carrinho.percurso.estagio.insert';
    _appSocket.socket.on(event, (data) {
      print('DATA $data');
      _liteners
          .where((element) => element.event == Event.insert)
          .forEach((element) {
        element.callback(data);
      });
    });
  }

  void _onUpdate() {
    const event = 'broadcast.carrinho.percurso.estagio.update';
    _appSocket.socket.on(event, (data) {
      _liteners
          .where((element) => element.event == Event.update)
          .forEach((element) {
        element.callback(data);
      });
    });
  }

  void _onDelete() {
    const event = 'broadcast.carrinho.percurso.estagio.delete';
    _appSocket.socket.on(event, (data) {
      _liteners
          .where((element) => element.event == Event.delete)
          .forEach((element) {
        element.callback(data);
      });
    });
  }
}
