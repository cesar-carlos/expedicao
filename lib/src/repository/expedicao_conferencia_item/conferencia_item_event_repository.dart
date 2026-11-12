import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/repository/socket_event_repository.dart';

class ConferenciaItemEventRepository extends SocketEventRepository {
  static ConferenciaItemEventRepository? _instancia;

  ConferenciaItemEventRepository._() {
    bind('conferencia.item.insert.listen', Event.insert);
    bind('conferencia.item.update.listen', Event.update);
    bind('conferencia.item.delete.listen', Event.delete);
  }

  static ConferenciaItemEventRepository get instancia {
    _instancia ??= ConferenciaItemEventRepository._();
    return _instancia!;
  }
}
