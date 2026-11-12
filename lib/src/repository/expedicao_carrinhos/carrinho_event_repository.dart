import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/repository/socket_event_repository.dart';

class CarrinhoEventRepository extends SocketEventRepository {
  static CarrinhoEventRepository? _instancia;

  CarrinhoEventRepository._() {
    bind('carrinho.insert.listen', Event.insert);
    bind('carrinho.update.listen', Event.update);
    bind('carrinho.delete.listen', Event.delete);
  }

  static CarrinhoEventRepository get instancia {
    _instancia ??= CarrinhoEventRepository._();
    return _instancia!;
  }
}
