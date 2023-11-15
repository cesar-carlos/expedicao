import 'package:app_expedicao/src/model/basic_event_model.dart';

enum Event {
  insert,
  update,
  delete,
}

class RepositoryEventListerModel<T> {
  Event event;

  Function(BasicEventModel<T> data) callback;
  RepositoryEventListerModel({required this.event, required this.callback});
}
