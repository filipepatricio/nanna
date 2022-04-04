import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_remote_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddBookmarkUseCase {
  AddBookmarkUseCase(this._bookmarkRepository, this._analyticsRepository);

  final BookmarkRepository _bookmarkRepository;
  final AnalyticsRepository _analyticsRepository;

  Future<BookmarkState>? call(Bookmark bookmark) {
    return bookmark.data.mapOrNull(
      article: (data) {
        _analyticsRepository.event(
          AnalyticsEvent.articleBookmarkAdded(data.article.id),
        );
        return _bookmarkRepository.bookmarkArticle(data.article.slug);
      },
      topic: (data) {
        _analyticsRepository.event(
          AnalyticsEvent.topicBookmarkAdded(data.topic.id),
        );
        return _bookmarkRepository.bookmarkTopic(data.topic.slug);
      },
    );
  }
}
