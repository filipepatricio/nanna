import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_remote_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_event.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/profile_bookmark_change_notifier.di.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/save_bookmarked_media_item_use_case.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddBookmarkUseCase {
  AddBookmarkUseCase(
    this._bookmarkRepository,
    this._analyticsRepository,
    this._profileBookmarkChangeNotifier,
    this._saveBookmarkedMediaItemUseCase,
  );

  final BookmarkRepository _bookmarkRepository;
  final AnalyticsRepository _analyticsRepository;
  final ProfileBookmarkChangeNotifier _profileBookmarkChangeNotifier;
  final SaveBookmarkedMediaItemUseCase _saveBookmarkedMediaItemUseCase;

  Future<BookmarkState>? call(Bookmark bookmark) {
    return bookmark.data.mapOrNull(
      article: (data) async {
        _analyticsRepository.event(
          AnalyticsEvent.articleBookmarkAdded(data.article.id),
        );

        final bookmarkState = await _bookmarkRepository.bookmarkArticle(data.article.slug);

        unawaited(
          bookmarkState.mapOrNull(
            bookmarked: (value) => _saveBookmarkedMediaItemUseCase.usingBookmarkData(data, value.id),
          ),
        );

        final bookmarkTypeData = BookmarkTypeData.article(data.article.slug, data.article.id, data.article.type);
        _profileBookmarkChangeNotifier.notify(
          BookmarkEvent(
            data: bookmarkTypeData,
            state: bookmarkState,
          ),
        );
        return bookmarkState;
      },
      topic: (data) async {
        _analyticsRepository.event(
          AnalyticsEvent.topicBookmarkAdded(data.topic.id),
        );

        final bookmarkState = await _bookmarkRepository.bookmarkTopic(data.topic.slug);

        unawaited(
          bookmarkState.mapOrNull(
            bookmarked: (value) => _saveBookmarkedMediaItemUseCase.usingBookmarkData(data, value.id),
          ),
        );

        final bookmarkTypeData = BookmarkTypeData.topic(data.topic.slug, data.topic.id);
        _profileBookmarkChangeNotifier.notify(
          BookmarkEvent(
            data: bookmarkTypeData,
            state: bookmarkState,
          ),
        );
        return bookmarkState;
      },
    );
  }
}
