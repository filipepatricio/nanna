import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_remote_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveBookmarkUseCase {
  RemoveBookmarkUseCase(this._bookmarkRepository, this._analyticsRepository);

  final BookmarkRepository _bookmarkRepository;
  final AnalyticsRepository _analyticsRepository;

  Future<void> call(Bookmark bookmark) async {
    await _bookmarkRepository.removeBookmark(bookmark.id);

    bookmark.data.mapOrNull(
      article: (data) => _analyticsRepository.event(
        AnalyticsEvent.articleBookmarkRemoved(data.article.id),
      ),
      topic: (data) => _analyticsRepository.event(
        AnalyticsEvent.topicBookmarkRemoved(data.topic.id),
      ),
    );
  }
}
