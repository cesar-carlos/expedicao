class BasicEventModel<T> {
  final String session;
  final String resposeIn;
  final T mutation;

  BasicEventModel({
    required this.session,
    required this.resposeIn,
    required this.mutation,
  });
}
