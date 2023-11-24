typedef Callback = void Function<T>(T parametro);

enum Event {
  insert,
  update,
  delete,
}

abstract class EventListenerContract {
  abstract String id;
  abstract Event event;
  abstract Callback callback;
  abstract bool allEvent;
}
