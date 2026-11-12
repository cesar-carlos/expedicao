import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/repository/socket_event_repository.dart';

class SepararEventRepository extends SocketEventRepository {
  static SepararEventRepository? _instancia;

  SepararEventRepository._() {
    bind('separar.insert.listen', Event.insert);
    bind('separar.update.listen', Event.update);
    bind('separar.delete.listen', Event.delete);
  }

  static SepararEventRepository get instancia {
    _instancia ??= SepararEventRepository._();
    return _instancia!;
  }
}
