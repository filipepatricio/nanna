import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_change_notifier.di.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_remote_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddBookmarkUseCase {
  AddBookmarkUseCase(
    this._bookmarkRepository,
    this._analyticsRepository,
    this._bookmarkChangeNotifier,
  );

  final BookmarkRepository _bookmarkRepository;
  final AnalyticsRepository _analyticsRepository;
  final BookmarkChangeNotifier _bookmarkChangeNotifier;

  Future<BookmarkState>? call(Bookmark bookmark) {
    return bookmark.data.mapOrNull(
      article: (data) async {
        _analyticsRepository.event(
          AnalyticsEvent.articleBookmarkAdded(data.article.id),
        );
        final bookmarkState = await _bookmarkRepository.bookmarkArticle(data.article.slug);
        _bookmarkChangeNotifier.notify(BookmarkTypeData.article(data.article.slug, data.article.id));
        return bookmarkState;
      },
      topic: (data) async {
        _analyticsRepository.event(
          AnalyticsEvent.topicBookmarkAdded(data.topic.id),
        );
        final bookmarkState = await _bookmarkRepository.bookmarkTopic(data.topic.slug);
        _bookmarkChangeNotifier.notify(BookmarkTypeData.topic(data.topic.slug, data.topic.id));
        return bookmarkState;
      },
    );
  }
}
