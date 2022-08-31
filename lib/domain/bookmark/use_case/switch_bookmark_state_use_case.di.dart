import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_change_notifier.di.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_remote_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_event.dart';
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
      notBookmarked: (state) => _addBookmark(data),
    );

    return newState;
  }

  Future<BookmarkState> _addBookmark(BookmarkTypeData data) async {
    _trackBookmarkAdded(data);
    final state = await data.map(
      article: (data) => _bookmarkRepository.bookmarkArticle(data.slug),
      topic: (data) => _bookmarkRepository.bookmarkTopic(data.slug),
    );

    _bookmarkChangeNotifier.notify(
      BookmarkEvent(
        data: data,
        state: state,
      ),
    );

    return state;
  }

  Future<BookmarkState> _removeBookmark(String id, BookmarkTypeData data) async {
    _trackBookmarkRemoved(data);
    final state = await _bookmarkRepository.removeBookmark(id);

    _bookmarkChangeNotifier.notify(
      BookmarkEvent(
        data: data,
        state: state,
      ),
    );

    return state;
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
