import 'dart:async';

import 'package:better_informed_mobile/domain/bookmark/data/bookmark_event.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ProfileBookmarkChangeNotifier {
  final StreamController<BookmarkEvent> _changeStream = StreamController.broadcast();

  Stream<BookmarkEvent> get stream => _changeStream.stream;

  void notify(BookmarkEvent event) {
    _changeStream.sink.add(event);
  }

  @disposeMethod
  void dispose() {
    _changeStream.close();
  }
}
