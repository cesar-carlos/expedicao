import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/repository/socket_event_repository.dart';

class ArmazenarEventRepository extends SocketEventRepository {
  static ArmazenarEventRepository? _instancia;

  ArmazenarEventRepository._() {
    bind('armazenar.insert.listen', Event.insert);
    bind('armazenar.update.listen', Event.update);
    bind('armazenar.delete.listen', Event.delete);
  }

  static ArmazenarEventRepository get instancia {
    _instancia ??= ArmazenarEventRepository._();
    return _instancia!;
  }
}
