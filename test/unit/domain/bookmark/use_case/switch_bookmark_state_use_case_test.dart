import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/switch_bookmark_state_use_case.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../generated_mocks.mocks.dart';

void main() {
  late MockBookmarkRepository bookmarkRepository;
  late MockBookmarkLocalRepository bookmarkLocalRepository;
  late MockAnalyticsRepository analyticsRepository;
  late MockBookmarkChangeNotifier bookmarkChangeNotifier;
  late MockSaveBookmarkedMediaItemUseCase saveBookmarkedMediaItemUseCase;
  late SwitchBookmarkStateUseCase useCase;

  setUp(() {
    bookmarkRepository = MockBookmarkRepository();
    bookmarkLocalRepository = MockBookmarkLocalRepository();
    analyticsRepository = MockAnalyticsRepository();
    bookmarkChangeNotifier = MockBookmarkChangeNotifier();
    saveBookmarkedMediaItemUseCase = MockSaveBookmarkedMediaItemUseCase();
    useCase = SwitchBookmarkStateUseCase(
      bookmarkRepository,
      bookmarkLocalRepository,
      analyticsRepository,
      bookmarkChangeNotifier,
      saveBookmarkedMediaItemUseCase,
    );
  });

  group('for article type', () {
    test('it bookmarks when not bookmarked', () async {
      const slug = 'article-slug';
      const id = '0000-0000';
      const articleId = '1111-1111';
      const type = BookmarkTypeData.article(slug, articleId);
      final state = BookmarkState.notBookmarked();
      final expected = BookmarkState.bookmarked(id);

      when(bookmarkRepository.bookmarkArticle(slug)).thenAnswer((_) async => BookmarkState.bookmarked(id));
      when(saveBookmarkedMediaItemUseCase.usingBookmarkType(type, id))
          .thenAnswer((realInvocation) => Future.delayed(const Duration(seconds: 10), () => null));

      final actual = await useCase(type, state).timeout(const Duration(seconds: 1));

      expect(actual, expected);

      verifyNever(bookmarkRepository.bookmarkTopic(any));
      verifyNever(bookmarkRepository.removeBookmark(any));
      verifyNever(bookmarkLocalRepository.deleteBookmark(id));
      verify(saveBookmarkedMediaItemUseCase.usingBookmarkType(type, id));
    });

    test('it unbookmarks when bookmarked', () async {
      const slug = 'article-slug';
      const id = '0000-0000';
      const articleId = '1111-1111';
      const type = BookmarkTypeData.article(slug, articleId);
      final state = BookmarkState.bookmarked(id);
      final expected = BookmarkState.notBookmarked();

      when(bookmarkRepository.removeBookmark(id)).thenAnswer((_) async => BookmarkState.notBookmarked());

      final actual = await useCase(type, state);

      expect(actual, expected);

      verifyNever(bookmarkRepository.bookmarkArticle(any));
      verifyNever(bookmarkRepository.bookmarkTopic(any));
      verifyNever(saveBookmarkedMediaItemUseCase.usingBookmarkType(any, any));
      verify(bookmarkLocalRepository.deleteBookmark(id));
    });
  });

  group('for topic type', () {
    test('it bookmarks when not bookmarked', () async {
      const slug = 'topic-slug';
      const id = '0000-0000';
      const topicId = '1111-1111';
      const type = BookmarkTypeData.topic(slug, topicId);
      final state = BookmarkState.notBookmarked();
      final expected = BookmarkState.bookmarked(id);

      when(bookmarkRepository.bookmarkTopic(slug)).thenAnswer((_) async => BookmarkState.bookmarked(id));
      when(saveBookmarkedMediaItemUseCase.usingBookmarkType(type, id))
          .thenAnswer((realInvocation) => Future.delayed(const Duration(seconds: 10), () => null));

      final actual = await useCase(type, state).timeout(const Duration(seconds: 1));

      expect(actual, expected);

      verifyNever(bookmarkRepository.bookmarkArticle(any));
      verifyNever(bookmarkRepository.removeBookmark(any));
      verifyNever(bookmarkLocalRepository.deleteBookmark(id));
      verify(saveBookmarkedMediaItemUseCase.usingBookmarkType(type, id));
    });

    test('it unbookmarks when bookmarked', () async {
      const slug = 'topic-slug';
      const id = '0000-0000';
      const topicId = '1111-1111';
      const type = BookmarkTypeData.topic(slug, topicId);
      final state = BookmarkState.bookmarked(id);
      final expected = BookmarkState.notBookmarked();

      when(bookmarkRepository.removeBookmark(id)).thenAnswer((_) async => BookmarkState.notBookmarked());

      final actual = await useCase(type, state);

      expect(actual, expected);

      verifyNever(bookmarkRepository.bookmarkArticle(any));
      verifyNever(bookmarkRepository.bookmarkTopic(any));
      verifyNever(saveBookmarkedMediaItemUseCase.usingBookmarkType(any, any));
      verify(bookmarkLocalRepository.deleteBookmark(id));
    });
  });
}
