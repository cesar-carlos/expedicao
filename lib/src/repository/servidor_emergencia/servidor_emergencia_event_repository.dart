import 'package:app_expedicao/src/model/repository_event_listener_model.dart';
import 'package:app_expedicao/src/repository/socket_event_repository.dart';

class ServidorEmergenciaEventRepository extends SocketEventRepository {
  static ServidorEmergenciaEventRepository? _instancia;

  ServidorEmergenciaEventRepository._() {
    bind('servidor.emergencia.listen', Event.emergencia);
  }

  static ServidorEmergenciaEventRepository get instancia {
    _instancia ??= ServidorEmergenciaEventRepository._();
    return _instancia!;
  }
}
