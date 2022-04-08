import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_change_notifier.di.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_remote_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class SwitchBookmarkStateUseCase {
  SwitchBookmarkStateUseCase(
    this._bookmarkRepository,
    this._analyticsRepository,
    this._bookmarkChangeNotifier,
  );

  final BookmarkRepository _bookmarkRepository;
  final AnalyticsRepository _analyticsRepository;
  final BookmarkChangeNotifier _bookmarkChangeNotifier;

  Future<BookmarkState> call(
    BookmarkTypeData data,
    BookmarkState state,
  ) async {
    final newState = await state.map(
      bookmarked: (state) => _removeBookmark(state.id, data),
      notBookmarked: (state) => _bookmark(data),
    );

    _bookmarkChangeNotifier.notify(data);

    return newState;
  }

  Future<BookmarkState> _bookmark(BookmarkTypeData data) async {
    _trackBookmarkAdded(data);
    return data.map(
      article: (data) => _bookmarkRepository.bookmarkArticle(data.slug),
      topic: (data) => _bookmarkRepository.bookmarkTopic(data.slug),
    );
  }

  Future<BookmarkState> _removeBookmark(String id, BookmarkTypeData data) async {
    _trackBookmarkRemoved(data);
    return _bookmarkRepository.removeBookmark(id);
  }

  void _trackBookmarkAdded(BookmarkTypeData data) {
    data.map(
      article: (data) => _analyticsRepository.event(
        AnalyticsEvent.articleBookmarkAdded(
          data.articleId,
          data.topicId,
          data.briefId,
        ),
      ),
      topic: (data) => _analyticsRepository.event(
        AnalyticsEvent.topicBookmarkAdded(
          data.topicId,
          data.briefId,
        ),
      ),
    );
  }

  void _trackBookmarkRemoved(BookmarkTypeData data) {
    data.map(
      article: (data) => _analyticsRepository.event(
        AnalyticsEvent.articleBookmarkRemoved(
          data.articleId,
          data.topicId,
          data.briefId,
        ),
      ),
      topic: (data) => _analyticsRepository.event(
        AnalyticsEvent.topicBookmarkRemoved(
          data.topicId,
          data.briefId,
        ),
      ),
    );
  }
}
