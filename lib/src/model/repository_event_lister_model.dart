import 'package:app_expedicao/src/model/basic_event_model.dart';

enum Event {
  insert,
  update,
  delete,
}

typedef Callback = void Function(BasicEventModel parametro);

class RepositoryEventListerModel {
  Event event;
  Callback callback;

  RepositoryEventListerModel({required this.event, required this.callback});
}
