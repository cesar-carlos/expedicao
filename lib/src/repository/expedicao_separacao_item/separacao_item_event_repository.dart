import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/repository/socket_event_repository.dart';

class SeparacaoItemEventRepository extends SocketEventRepository {
  static SeparacaoItemEventRepository? _instancia;

  SeparacaoItemEventRepository._() {
    bind('separacao.item.insert.listen', Event.insert);
    bind('separacao.item.update.listen', Event.update);
    bind('separacao.item.delete.listen', Event.delete);
  }

  static SeparacaoItemEventRepository get instancia {
    _instancia ??= SeparacaoItemEventRepository._();
    return _instancia!;
  }
}
