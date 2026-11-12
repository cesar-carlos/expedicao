import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/repository/socket_event_repository.dart';

class UsuarioEventRepository extends SocketEventRepository {
  static UsuarioEventRepository? _instancia;

  UsuarioEventRepository._() {
    bind('usuario.insert.listen', Event.insert);
    bind('usuario.update.listen', Event.update);
    bind('usuario.delete.listen', Event.delete);
  }

  static UsuarioEventRepository get instancia {
    _instancia ??= UsuarioEventRepository._();
    return _instancia!;
  }
}
