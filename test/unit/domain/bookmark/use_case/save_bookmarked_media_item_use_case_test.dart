import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/save_bookmarked_media_item_use_case.di.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
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
  late MockSaveSynchronizableItemUseCase saveSynchronizableItemUseCase;

  late SaveBookmarkedMediaItemUseCase useCase;

  setUp(() {
    articleRepository = MockArticleRepository();
    topicsRepository = MockTopicsRepository();
    bookmarkLocalRepository = MockBookmarkLocalRepository();
    saveArticleLocallyUseCase = MockSaveArticleLocallyUseCase();
    saveTopicLocallyUseCase = MockSaveTopicLocallyUseCase();
    hasActiveSubscriptionUseCase = MockHasActiveSubscriptionUseCase();
    saveSynchronizableItemUseCase = MockSaveSynchronizableItemUseCase();

    when(saveSynchronizableItemUseCase(any, any)).thenAnswer((_) async {});

    useCase = SaveBookmarkedMediaItemUseCase(
      articleRepository,
      topicsRepository,
      bookmarkLocalRepository,
      saveArticleLocallyUseCase,
      saveTopicLocallyUseCase,
      hasActiveSubscriptionUseCase,
      saveSynchronizableItemUseCase,
    );
  });

  group('usingBookmarkType', () {
    test('save article bookmark', () async {
      final article = TestData.article;
      const bookmarkId = 'bookmarkId';
      const bookmarkType = BookmarkTypeData.article('slug', 'id');

      when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => true);
      when(articleRepository.getArticleHeader('slug')).thenAnswer((_) async => article);

      await useCase.usingBookmarkType(bookmarkType, bookmarkId);

      final capturedBookmark =
          verify(saveSynchronizableItemUseCase(bookmarkLocalRepository, captureAny)).captured.single;
      expect(
        capturedBookmark,
        isA<Synchronizable<Bookmark>>()
            .having((synchronizable) => synchronizable.data?.id, 'data.id', bookmarkId)
            .having((synchronizable) => synchronizable.dataId, 'dataId', bookmarkId),
      );

      verify(saveArticleLocallyUseCase.fetchDetailsAndSave(article, bookmarkExpirationTime));
    });

    test('save topic bookmark', () async {
      final topic = TestData.topic;
      const bookmarkId = 'bookmarkId';
      const bookmarkType = BookmarkTypeData.topic('slug', 'id');

      when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => true);
      when(topicsRepository.getTopicBySlug('slug')).thenAnswer((_) async => topic);

      await useCase.usingBookmarkType(bookmarkType, bookmarkId);

      final capturedBookmark =
          verify(saveSynchronizableItemUseCase(bookmarkLocalRepository, captureAny)).captured.single;
      expect(
        capturedBookmark,
        isA<Synchronizable<Bookmark>>()
            .having((synchronizable) => synchronizable.data?.id, 'data.id', bookmarkId)
            .having((synchronizable) => synchronizable.dataId, 'dataId', bookmarkId),
      );

      verify(saveTopicLocallyUseCase.save(topic, bookmarkExpirationTime));
    });

    test('skip for unsubscribed user', () async {
      const bookmarkId = 'bookmarkId';
      const bookmark = BookmarkTypeData.article('slug', 'id');

      when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => false);

      await useCase.usingBookmarkType(bookmark, bookmarkId);

      verifyNever(saveSynchronizableItemUseCase(bookmarkLocalRepository, any));
      verifyNever(articleRepository.getArticleHeader(any));
      verifyNever(saveArticleLocallyUseCase.fetchDetailsAndSave(any, bookmarkExpirationTime));
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

      final capturedBookmark =
          verify(saveSynchronizableItemUseCase(bookmarkLocalRepository, captureAny)).captured.single;
      expect(
        capturedBookmark,
        isA<Synchronizable<Bookmark>>()
            .having((synchronizable) => synchronizable.data?.id, 'data.id', bookmarkId)
            .having((synchronizable) => synchronizable.dataId, 'dataId', bookmarkId),
      );

      verifyNever(articleRepository.getArticleHeader(any));
      verify(saveArticleLocallyUseCase.fetchDetailsAndSave(article, bookmarkExpirationTime));
    });

    test('save topic bookmark', () async {
      final topic = TestData.topic;
      const bookmarkId = 'bookmarkId';
      final bookmark = BookmarkData.topic(topic);

      when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => true);

      await useCase.usingBookmarkData(bookmark, bookmarkId);

      final capturedBookmark =
          verify(saveSynchronizableItemUseCase(bookmarkLocalRepository, captureAny)).captured.single;
      expect(
        capturedBookmark,
        isA<Synchronizable<Bookmark>>()
            .having((synchronizable) => synchronizable.data?.id, 'data.id', bookmarkId)
            .having((synchronizable) => synchronizable.dataId, 'dataId', bookmarkId),
      );

      verifyNever(topicsRepository.getTopicBySlug(any));
      verify(saveTopicLocallyUseCase.save(topic, bookmarkExpirationTime));
    });

    test('skip for unsubscribed user', () async {
      final article = TestData.article;
      const bookmarkId = 'bookmarkId';
      final bookmark = BookmarkData.article(article);

      when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => false);

      await useCase.usingBookmarkData(bookmark, bookmarkId);

      verifyNever(saveSynchronizableItemUseCase(bookmarkLocalRepository, any));
      verifyNever(articleRepository.getArticleHeader(any));
      verifyNever(saveArticleLocallyUseCase.fetchDetailsAndSave(any, bookmarkExpirationTime));
    });
  });
}
