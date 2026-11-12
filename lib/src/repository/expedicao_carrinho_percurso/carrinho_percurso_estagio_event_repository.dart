import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/repository/socket_event_repository.dart';

class CarrinhoPercursoEstagioEventRepository extends SocketEventRepository {
  static CarrinhoPercursoEstagioEventRepository? _instancia;

  CarrinhoPercursoEstagioEventRepository._() {
    bind('carrinho.percurso.estagio.insert.listen', Event.insert);
    bind('carrinho.percurso.estagio.update.listen', Event.update);
    bind('carrinho.percurso.estagio.delete.listen', Event.delete);
  }

  static CarrinhoPercursoEstagioEventRepository get instancia {
    _instancia ??= CarrinhoPercursoEstagioEventRepository._();
    return _instancia!;
  }
}
