import 'package:app_expedicao/src/model/basic_event_model.dart';

enum Event {
  insert,
  update,
  delete,
}

typedef Callback = void Function(BasicEventModel parametro);

class RepositoryEventListenerModel {
  String id;
  Event event;
  Callback callback;
  bool allEvent;

  RepositoryEventListenerModel({
    required this.id,
    required this.event,
    required this.callback,
    this.allEvent = false,
  });
}
