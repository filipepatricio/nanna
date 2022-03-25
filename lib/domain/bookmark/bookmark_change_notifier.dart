import 'dart:async';

import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dart';
import 'package:injectable/injectable.dart';

@singleton
class BookmarkChangeNotifier {
  final StreamController<List<BookmarkFilter>> _changeStream = StreamController.broadcast();

  Stream<List<BookmarkFilter>> get stream => _changeStream.stream;

  void notify(BookmarkTypeData type) {
    final filters = [BookmarkFilter.all] +
        type.map(
          article: (_) => [BookmarkFilter.article],
          topic: (_) => [BookmarkFilter.topic],
        );
    _changeStream.sink.add(filters);
  }
}
