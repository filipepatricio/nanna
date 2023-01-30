import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_event.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/remove_bookmark_use_case.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../generated_mocks.mocks.dart';
import '../../../../test_data.dart';

void main() {
  late RemoveBookmarkUseCase useCase;
  late MockBookmarkRepository bookmarkRepository;
  late MockBookmarkLocalRepository bookmarkLocalRepository;
  late MockAnalyticsRepository analyticsRepository;
  late MockProfileBookmarkChangeNotifier profileBookmarkChangeNotifier;

  setUp(() {
    bookmarkRepository = MockBookmarkRepository();
    bookmarkLocalRepository = MockBookmarkLocalRepository();
    analyticsRepository = MockAnalyticsRepository();
    profileBookmarkChangeNotifier = MockProfileBookmarkChangeNotifier();
    useCase = RemoveBookmarkUseCase(
      bookmarkRepository,
      bookmarkLocalRepository,
      analyticsRepository,
      profileBookmarkChangeNotifier,
    );
  });

  group('on call', () {
    final article = TestData.article;
    final bookmark = Bookmark(
      'id',
      BookmarkData.article(article),
    );

    setUp(() {
      when(bookmarkRepository.removeBookmark(bookmark.id)).thenAnswer((_) async => BookmarkState.notBookmarked());
    });

    test('should remove bookmark from remote repository', () async {
      await useCase(bookmark);

      verify(bookmarkRepository.removeBookmark(bookmark.id));
    });

    test('should remove bookmark from local repository', () async {
      await useCase(bookmark);

      verify(bookmarkLocalRepository.deleteBookmark(bookmark.id));
    });

    test('should notify profile bookmark change notifier', () async {
      await useCase(bookmark);

      final captured = verify(profileBookmarkChangeNotifier.notify(captureAny)).captured.single;

      expect(
        captured,
        isA<BookmarkEvent>()
            .having((p0) => p0.state, 'state', BookmarkState.notBookmarked())
            .having((p0) => p0.data, 'data', BookmarkTypeData.article(article.slug, article.id)),
      );
    });

    test('should send analytics event', () async {
      await useCase(bookmark);

      verify(analyticsRepository.event(AnalyticsEvent.articleBookmarkRemoved(article.id)));
    });
  });
}
