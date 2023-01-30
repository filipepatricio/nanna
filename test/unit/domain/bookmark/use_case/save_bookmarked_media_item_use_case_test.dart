import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/save_bookmarked_media_item_use_case.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../generated_mocks.mocks.dart';
import '../../../../test_data.dart';

void main() {
  late MockArticleRepository articleRepository;
  late MockTopicsRepository topicsRepository;
  late MockBookmarkLocalRepository bookmarkLocalRepository;
  late MockSaveArticleLocallyUseCase saveArticleLocallyUseCase;
  late MockSaveTopicLocallyUseCase saveTopicLocallyUseCase;
  late MockHasActiveSubscriptionUseCase hasActiveSubscriptionUseCase;

  late SaveBookmarkedMediaItemUseCase useCase;

  setUp(() {
    articleRepository = MockArticleRepository();
    topicsRepository = MockTopicsRepository();
    bookmarkLocalRepository = MockBookmarkLocalRepository();
    saveArticleLocallyUseCase = MockSaveArticleLocallyUseCase();
    saveTopicLocallyUseCase = MockSaveTopicLocallyUseCase();
    hasActiveSubscriptionUseCase = MockHasActiveSubscriptionUseCase();

    useCase = SaveBookmarkedMediaItemUseCase(
      articleRepository,
      topicsRepository,
      bookmarkLocalRepository,
      saveArticleLocallyUseCase,
      saveTopicLocallyUseCase,
      hasActiveSubscriptionUseCase,
    );
  });

  group('usingBookmarkType', () {
    test('save article bookmark', () async {
      final article = TestData.article;
      const bookmarkId = 'bookmarkId';
      const bookmarkType = BookmarkTypeData.article('slug', 'id');
      final bookmark = BookmarkData.article(article);

      when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => true);
      when(articleRepository.getArticleHeader('slug')).thenAnswer((_) async => article);

      await useCase.usingBookmarkType(bookmarkType, bookmarkId);

      final capturedBookmark = verify(bookmarkLocalRepository.saveBookmark(captureAny)).captured.single;
      expect(
        capturedBookmark,
        isA<Bookmark>()
            .having((bookmark) => bookmark.id, 'id', bookmarkId)
            .having((bookmark) => bookmark.data, 'data', bookmark),
      );

      verify(saveArticleLocallyUseCase.fetchDetailsAndSave(article));
    });

    test('save topic bookmark', () async {
      final topic = TestData.topic;
      const bookmarkId = 'bookmarkId';
      const bookmarkType = BookmarkTypeData.topic('slug', 'id');
      final bookmark = BookmarkData.topic(topic);

      when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => true);
      when(topicsRepository.getTopicBySlug('slug')).thenAnswer((_) async => topic);

      await useCase.usingBookmarkType(bookmarkType, bookmarkId);

      final capturedBookmark = verify(bookmarkLocalRepository.saveBookmark(captureAny)).captured.single;
      expect(
        capturedBookmark,
        isA<Bookmark>()
            .having((bookmark) => bookmark.id, 'id', bookmarkId)
            .having((bookmark) => bookmark.data, 'data', bookmark),
      );

      verify(saveTopicLocallyUseCase.save(topic));
    });

    test('skip for unsubscribed user', () async {
      const bookmarkId = 'bookmarkId';
      const bookmark = BookmarkTypeData.article('slug', 'id');

      when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => false);

      await useCase.usingBookmarkType(bookmark, bookmarkId);

      verifyNever(bookmarkLocalRepository.saveBookmark(any));
      verifyNever(articleRepository.getArticleHeader(any));
      verifyNever(saveArticleLocallyUseCase.fetchDetailsAndSave(any));
    });
  });

  group('usingBookmarkData', () {
    test('save article bookmark', () async {
      final article = TestData.article;
      const bookmarkId = 'bookmarkId';
      final bookmark = BookmarkData.article(article);

      when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => true);

      await useCase.usingBookmarkData(bookmark, bookmarkId);
      when(articleRepository.getArticleHeader('slug')).thenAnswer((_) async => article);

      final capturedBookmark = verify(bookmarkLocalRepository.saveBookmark(captureAny)).captured.single;
      expect(
        capturedBookmark,
        isA<Bookmark>()
            .having((bookmark) => bookmark.id, 'id', bookmarkId)
            .having((bookmark) => bookmark.data, 'data', bookmark),
      );

      verifyNever(articleRepository.getArticleHeader(any));
      verify(saveArticleLocallyUseCase.fetchDetailsAndSave(article));
    });

    test('save topic bookmark', () async {
      final topic = TestData.topic;
      const bookmarkId = 'bookmarkId';
      final bookmark = BookmarkData.topic(topic);

      when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => true);

      await useCase.usingBookmarkData(bookmark, bookmarkId);

      final capturedBookmark = verify(bookmarkLocalRepository.saveBookmark(captureAny)).captured.single;
      expect(
        capturedBookmark,
        isA<Bookmark>()
            .having((bookmark) => bookmark.id, 'id', bookmarkId)
            .having((bookmark) => bookmark.data, 'data', bookmark),
      );

      verifyNever(topicsRepository.getTopicBySlug(any));
      verify(saveTopicLocallyUseCase.save(topic));
    });

    test('skip for unsubscribed user', () async {
      final article = TestData.article;
      const bookmarkId = 'bookmarkId';
      final bookmark = BookmarkData.article(article);

      when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => false);

      await useCase.usingBookmarkData(bookmark, bookmarkId);

      verifyNever(bookmarkLocalRepository.saveBookmark(any));
      verifyNever(articleRepository.getArticleHeader(any));
      verifyNever(saveArticleLocallyUseCase.fetchDetailsAndSave(any));
    });
  });
}
