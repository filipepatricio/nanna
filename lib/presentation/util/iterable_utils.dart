import 'package:flutter/material.dart';

extension NestedIterable<T> on Iterable<Iterable<T>> {
  Iterable<T> get flattened sync* {
    for (final i in this) {
      yield* i;
    }
  }
}

extension IterableExtension on Iterable<Widget> {
  /// Adds a [Divider] before the first widget, between all widgets, and after the last widget.
  List<Widget> withDividers({bool beforeFirst = false, bool afterLast = false, Widget divider = const Divider()}) {
    if (isEmpty) {
      return [];
    }
    final result = <Widget>[if (beforeFirst) const Divider()];
    for (final widget in this) {
      result
        ..add(widget)
        ..add(divider);
    }
    if (!afterLast) {
      result.removeLast();
    }
    return result;
  }
}
