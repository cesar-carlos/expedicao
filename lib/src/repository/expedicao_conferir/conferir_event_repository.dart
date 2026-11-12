import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/repository/socket_event_repository.dart';

class ConferirEventRepository extends SocketEventRepository {
  static ConferirEventRepository? _instancia;

  ConferirEventRepository._() {
    bind('conferir.insert.listen', Event.insert);
    bind('conferir.update.listen', Event.update);
    bind('conferir.delete.listen', Event.delete);
  }

  static ConferirEventRepository get instancia {
    _instancia ??= ConferirEventRepository._();
    return _instancia!;
  }
}
