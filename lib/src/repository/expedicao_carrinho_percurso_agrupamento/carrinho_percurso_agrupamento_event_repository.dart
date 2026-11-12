import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/repository/socket_event_repository.dart';

class CarrinhoPercursoAgrupamentoEventRepository extends SocketEventRepository {
  static CarrinhoPercursoAgrupamentoEventRepository? _instancia;

  CarrinhoPercursoAgrupamentoEventRepository._() {
    bind('carrinho.percurso.agrupamento.insert.listen', Event.insert);
    bind('carrinho.percurso.agrupamento.update.listen', Event.update);
    bind('carrinho.percurso.agrupamento.delete.listen', Event.delete);
  }

  static CarrinhoPercursoAgrupamentoEventRepository get instancia {
    _instancia ??= CarrinhoPercursoAgrupamentoEventRepository._();
    return _instancia!;
  }
}
