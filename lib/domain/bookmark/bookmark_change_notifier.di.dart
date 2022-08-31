import 'dart:async';

import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:injectable/injectable.dart';

@singleton
class BookmarkChangeNotifier {
  final StreamController<BookmarkTypeData> _changeStream = StreamController.broadcast();

  Stream<BookmarkTypeData> get stream => _changeStream.stream;

  void notify(BookmarkTypeData type) {
    _changeStream.sink.add(type);
  }

  @disposeMethod
  void dispose() {
    _changeStream.close();
  }
}
