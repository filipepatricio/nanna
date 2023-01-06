import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:injectable/injectable.dart';

@singleton
class ShouldRefreshArticleProgressStateNotifier {
  final StreamController<MediaItemArticle> _changeStream = StreamController.broadcast();

  Stream<MediaItemArticle> get stream => _changeStream.stream;

  void notify(MediaItemArticle article) {
    _changeStream.sink.add(article);
  }

  @disposeMethod
  void dispose() {
    _changeStream.close();
  }
}
