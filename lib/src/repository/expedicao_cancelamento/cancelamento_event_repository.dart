import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/repository/socket_event_repository.dart';

class CancelamentoEventRepository extends SocketEventRepository {
  static CancelamentoEventRepository? _instancia;

  CancelamentoEventRepository._() {
    bind('expedicao.cancelamento.insert.listen', Event.insert);
    bind('expedicao.cancelamento.update.listen', Event.update);
    bind('expedicao.cancelamento.delete.listen', Event.delete);
  }

  static CancelamentoEventRepository get instancia {
    _instancia ??= CancelamentoEventRepository._();
    return _instancia!;
  }
}
