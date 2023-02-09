import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_remote_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_event.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/profile_bookmark_change_notifier.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveBookmarkUseCase {
  RemoveBookmarkUseCase(
    this._bookmarkRepository,
    this._bookmarkLocalRepository,
    this._analyticsRepository,
    this._profileBookmarkChangeNotifier,
  );

  final BookmarkRepository _bookmarkRepository;
  final BookmarkLocalRepository _bookmarkLocalRepository;
  final AnalyticsRepository _analyticsRepository;
  final ProfileBookmarkChangeNotifier _profileBookmarkChangeNotifier;

  Future<void> call(Bookmark bookmark) async {
    final bookmarkState = await _bookmarkRepository.removeBookmark(bookmark.id);
    await _bookmarkLocalRepository.delete(bookmark.id);

    bookmark.data.mapOrNull(
      article: (data) {
        _analyticsRepository.event(AnalyticsEvent.articleBookmarkRemoved(data.article.id));
        final bookmarkTypeData = BookmarkTypeData.article(data.article.slug, data.article.id, data.article.type);
        _profileBookmarkChangeNotifier.notify(
          BookmarkEvent(
            data: bookmarkTypeData,
            state: bookmarkState,
          ),
        );
      },
      topic: (data) {
        _analyticsRepository.event(AnalyticsEvent.topicBookmarkRemoved(data.topic.id));
        final bookmarkTypeData = BookmarkTypeData.topic(data.topic.slug, data.topic.id);
        _profileBookmarkChangeNotifier.notify(
          BookmarkEvent(
            data: bookmarkTypeData,
            state: bookmarkState,
          ),
        );
      },
    );
  }
}
