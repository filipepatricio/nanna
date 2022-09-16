extension NestedIterable<T> on Iterable<Iterable<T>> {
  Iterable<T> get flattened sync* {
    for (final i in this) {
      yield* i;
    }
  }
}
