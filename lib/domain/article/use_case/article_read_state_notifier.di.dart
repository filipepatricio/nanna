import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ArticleReadStateNotifier {
  final StreamController<MediaItemArticle> _changeStream = StreamController.broadcast();
  final Map<String, MediaItemArticle> _articles = {};

  Stream<MediaItemArticle> get stream async* {
    for (final article in _articles.values) {
      yield article;
    }

    yield* _changeStream.stream;
  }

  void notify(MediaItemArticle article) {
    if (!_changeStream.isClosed) {
      _articles[article.slug] = article;
      _changeStream.sink.add(article);
    }
  }

  MediaItemArticle? getArticle(String slug) => _articles[slug];

  @disposeMethod
  void dispose() {
    _articles.clear();
    _changeStream.close();
  }
}
