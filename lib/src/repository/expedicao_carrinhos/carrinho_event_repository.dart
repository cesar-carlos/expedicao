import 'package:get/get.dart';

import 'package:app_expedicao/src/app/app_socket.config.dart';
import 'package:app_expedicao/src/model/repository_event_lister_model.dart';

class CarrinhoEventRepository {
  static CarrinhoEventRepository? _instancia;
  final List<RepositoryEventListerModel> _liteners = [];

  final _appSocket = Get.find<AppSocketConfig>();

  CarrinhoEventRepository._() {
    _onInsert();
    _onUpdate();
    _onDelete();
  }

  static CarrinhoEventRepository get instancia {
    _instancia ??= CarrinhoEventRepository._();
    return _instancia!;
  }

  addListener<T>(RepositoryEventListerModel<T> listerner) {
    _liteners.add(listerner);
  }

  removeListener<T>(RepositoryEventListerModel<T> listerner) {
    _liteners.remove(listerner);
  }

  void _onInsert() {
    const event = 'broadcast.carrinho.insert';
    _appSocket.socket.on(event, (data) {
      _liteners
          .where((element) => element.event == Event.insert)
          .forEach((element) {
        element.callback(data);
      });
    });
  }

  void _onUpdate() {
    const event = 'broadcast.carrinho.update';
    _appSocket.socket.on(event, (data) {
      print('broadcast update $data');

      _liteners
          .where((element) => element.event == Event.update)
          .forEach((element) {
        print('broadcast update $data');
        element.callback(data);
      });
    });
  }

  void _onDelete() {
    const event = 'broadcast.carrinho.delete';
    _appSocket.socket.on(event, (data) {
      _liteners
          .where((element) => element.event == Event.delete)
          .forEach((element) {
        element.callback(data);
      });
    });
  }
}
