import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/repository/socket_event_repository.dart';

class ArmazenarItemEventRepository extends SocketEventRepository {
  static ArmazenarItemEventRepository? _instancia;

  ArmazenarItemEventRepository._() {
    bind('armazenar.item.insert.listen', Event.insert);
    bind('armazenar.item.update.listen', Event.update);
    bind('armazenar.item.delete.listen', Event.delete);
  }

  static ArmazenarItemEventRepository get instancia {
    _instancia ??= ArmazenarItemEventRepository._();
    return _instancia!;
  }
}
