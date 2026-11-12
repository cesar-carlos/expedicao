import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/repository/socket_event_repository.dart';

class ConferirItemEventRepository extends SocketEventRepository {
  static ConferirItemEventRepository? _instancia;

  ConferirItemEventRepository._() {
    bind('conferir.item.insert.listen', Event.insert);
    bind('conferir.item.update.listen', Event.update);
    bind('conferir.item.delete.listen', Event.delete);
  }

  static ConferirItemEventRepository get instancia {
    _instancia ??= ConferirItemEventRepository._();
    return _instancia!;
  }
}
