import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/repository/socket_event_repository.dart';

class SepararItemEventRepository extends SocketEventRepository {
  static SepararItemEventRepository? _instancia;

  SepararItemEventRepository._() {
    bind('separar.item.insert.listen', Event.insert);
    bind('separar.item.consulta.update.listen', Event.update);
    bind('separar.item.delete.listen', Event.delete);
  }

  static SepararItemEventRepository get instancia {
    _instancia ??= SepararItemEventRepository._();
    return _instancia!;
  }
}
