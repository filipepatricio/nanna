import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/add_bookmark_use_case.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../generated_mocks.mocks.dart';
import '../../../../test_data.dart';

void main() {
  late MockBookmarkRepository mockBookmarkRepository;
  late MockAnalyticsRepository mockAnalyticsRepository;
  late MockProfileBookmarkChangeNotifier mockProfileBookmarkChangeNotifier;
  late MockSaveBookmarkedMediaItemUseCase mockSaveBookmarkedMediaItemUseCase;
  late AddBookmarkUseCase addBookmarkUseCase;

  setUp(() {
    mockBookmarkRepository = MockBookmarkRepository();
    mockAnalyticsRepository = MockAnalyticsRepository();
    mockProfileBookmarkChangeNotifier = MockProfileBookmarkChangeNotifier();
    mockSaveBookmarkedMediaItemUseCase = MockSaveBookmarkedMediaItemUseCase();
    addBookmarkUseCase = AddBookmarkUseCase(
      mockBookmarkRepository,
      mockAnalyticsRepository,
      mockProfileBookmarkChangeNotifier,
      mockSaveBookmarkedMediaItemUseCase,
    );
  });

  group('for article', () {
    test('bookmarks with success', () async {
      final article = TestData.article;
      const bookmarkId = 'bookmarkId';
      final bookmarkData = BookmarkData.article(article);
      final bookmark = Bookmark(
        bookmarkId,
        bookmarkData,
      );
      final expected = BookmarkState.bookmarked(bookmarkId);

      when(mockBookmarkRepository.bookmarkArticle(article.slug)).thenAnswer((_) async => expected);
      when(mockSaveBookmarkedMediaItemUseCase.usingBookmarkData(bookmarkData, bookmarkId))
          .thenAnswer((_) => Future.delayed(const Duration(seconds: 10)));

      final bookmarkState = await addBookmarkUseCase(bookmark)!.timeout(const Duration(seconds: 1));

      expect(bookmarkState, expected);

      verify(mockAnalyticsRepository.event(AnalyticsEvent.articleBookmarkAdded(article.id)));
      verify(mockSaveBookmarkedMediaItemUseCase.usingBookmarkData(bookmarkData, bookmarkId));
    });
  });

  group('for topic', () {
    test('bookmarks with success', () async {
      final topic = TestData.topic;
      const bookmarkId = 'bookmarkId';
      final bookmarkData = BookmarkData.topic(topic);
      final bookmark = Bookmark(
        bookmarkId,
        bookmarkData,
      );
      final expected = BookmarkState.bookmarked(bookmarkId);

      when(mockBookmarkRepository.bookmarkTopic(topic.slug)).thenAnswer((_) async => expected);
      when(mockSaveBookmarkedMediaItemUseCase.usingBookmarkData(bookmarkData, bookmarkId))
          .thenAnswer((_) => Future.delayed(const Duration(seconds: 10)));

      final bookmarkState = await addBookmarkUseCase(bookmark)!.timeout(const Duration(seconds: 1));

      expect(bookmarkState, expected);

      verify(mockAnalyticsRepository.event(AnalyticsEvent.topicBookmarkAdded(topic.id)));
      verify(mockSaveBookmarkedMediaItemUseCase.usingBookmarkData(bookmarkData, bookmarkId));
    });
  });
}
