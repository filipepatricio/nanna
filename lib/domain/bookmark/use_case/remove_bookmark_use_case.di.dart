import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_change_notifier.di.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_remote_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveBookmarkUseCase {
  RemoveBookmarkUseCase(
    this._bookmarkRepository,
    this._analyticsRepository,
    this._bookmarkChangeNotifier,
  );

  final BookmarkRepository _bookmarkRepository;
  final AnalyticsRepository _analyticsRepository;
  final BookmarkChangeNotifier _bookmarkChangeNotifier;

  Future<void> call(Bookmark bookmark) async {
    await _bookmarkRepository.removeBookmark(bookmark.id);

    bookmark.data.mapOrNull(
      article: (data) {
        _analyticsRepository.event(AnalyticsEvent.articleBookmarkRemoved(data.article.id));
        _bookmarkChangeNotifier.notify(BookmarkTypeData.article(data.article.slug, data.article.id));
      },
      topic: (data) {
        _analyticsRepository.event(AnalyticsEvent.topicBookmarkRemoved(data.topic.id));
        _bookmarkChangeNotifier.notify(BookmarkTypeData.article(data.topic.slug, data.topic.id));
      },
    );
  }
}
