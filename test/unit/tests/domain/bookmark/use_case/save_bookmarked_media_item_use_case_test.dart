import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/save_bookmarked_media_item_use_case.di.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../generated_mocks.mocks.dart';
import '../../../../../test_data.dart';

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
      const bookmarkType = BookmarkTypeData.article('slug', 'id', ArticleType.premium);

      when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => true);
      when(articleRepository.getArticleHeader('slug')).thenAnswer((_) async => article);

      await useCase.usingBookmarkType(bookmarkType, bookmarkId);

      final capturedBookmark =
          verify(saveSynchronizableItemUseCase(bookmarkLocalRepository, captureAny)).captured.single;
      expect(
        capturedBookmark,
        isA<Synchronized<Bookmark>>()
            .having((synchronizable) => synchronizable.data.id, 'data.id', bookmarkId)
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
        isA<Synchronized<Bookmark>>()
            .having((synchronizable) => synchronizable.data.id, 'data.id', bookmarkId)
            .having((synchronizable) => synchronizable.dataId, 'dataId', bookmarkId),
      );

      verify(saveTopicLocallyUseCase.save(topic, bookmarkExpirationTime));
    });

    test('skip for unsubscribed user', () async {
      const bookmarkId = 'bookmarkId';
      const bookmark = BookmarkTypeData.article('slug', 'id', ArticleType.premium);

      when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => false);

      await useCase.usingBookmarkType(bookmark, bookmarkId);

      verifyNever(saveSynchronizableItemUseCase(bookmarkLocalRepository, any));
      verifyNever(articleRepository.getArticleHeader(any));
      verifyNever(saveArticleLocallyUseCase.fetchDetailsAndSave(any, bookmarkExpirationTime));
    });

    test('skip saving freemium article', () async {
      final article = TestData.article.copyWith(type: ArticleType.free);
      const bookmarkId = 'bookmarkId';
      const bookmark = BookmarkTypeData.article('slug', 'id', ArticleType.free);

      when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => true);
      when(articleRepository.getArticleHeader('slug')).thenAnswer((_) async => article);

      await useCase.usingBookmarkType(bookmark, bookmarkId);

      verify(articleRepository.getArticleHeader(any));
      verify(saveSynchronizableItemUseCase(bookmarkLocalRepository, any));
      verifyNever(saveArticleLocallyUseCase.fetchDetailsAndSave(article, bookmarkExpirationTime));
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
        isA<Synchronized<Bookmark>>()
            .having((synchronizable) => synchronizable.data.id, 'data.id', bookmarkId)
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
        isA<Synchronized<Bookmark>>()
            .having((synchronizable) => synchronizable.data.id, 'data.id', bookmarkId)
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

      verifyNever(saveSynchronizableItemUseCase(any, any));
      verifyNever(articleRepository.getArticleHeader(any));
      verifyNever(saveArticleLocallyUseCase.fetchDetailsAndSave(any, any));
    });
  });

  group('usingBookmarkList', () {
    test('skip for unsubscribed user', () async {
      final bookmark0 = Bookmark('000', BookmarkData.article(TestData.article.copyWith(slug: '000')));
      final bookmark1 = Bookmark('001', BookmarkData.article(TestData.article.copyWith(slug: '001')));
      final bookmarks = [bookmark0, bookmark1];

      when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => false);

      await useCase.usingBookmarkList(bookmarks);

      verifyNever(saveSynchronizableItemUseCase(any, any));
      verifyNever(saveTopicLocallyUseCase.save(any, any));
      verifyNever(saveArticleLocallyUseCase.fetchDetailsAndSave(any, any));
    });

    test('saves only premium articles', () async {
      final article0 = TestData.article.copyWith(slug: '000');
      final article1 = TestData.article.copyWith(slug: '001', type: ArticleType.free);
      final article2 = TestData.article.copyWith(slug: '002');
      final bookmark0 = Bookmark('000', BookmarkData.article(article0));
      final bookmark1 = Bookmark('001', BookmarkData.article(article1));
      final bookmark2 = Bookmark('002', BookmarkData.article(article2));
      final bookmarks = [bookmark0, bookmark1, bookmark2];

      when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => true);
      when(saveArticleLocallyUseCase.fetchListAndSave(any, bookmarkExpirationTime))
          .thenAnswer((realInvocation) async {});
      when(articleRepository.getArticleHeader('000')).thenAnswer((_) async => article0);
      when(articleRepository.getArticleHeader('001')).thenAnswer((_) async => article1);

      await useCase.usingBookmarkList(bookmarks);

      verify(saveArticleLocallyUseCase.fetchListAndSave(['000', '002'], bookmarkExpirationTime));
    });
  });
}
