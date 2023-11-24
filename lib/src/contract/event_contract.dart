import 'package:app_expedicao/src/model/repository_event_listener_model.dart';

abstract class EventContract {
  List<RepositoryEventListenerModel> get listener;
  void addListener(RepositoryEventListenerModel listerner);
  void removeListener(RepositoryEventListenerModel listerner);
}
