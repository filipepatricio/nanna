import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_data.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/run_initial_bookmark_sync_use_case.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../generated_mocks.mocks.dart';
import '../../../../../test_data.dart';

void main() {
  late MockBookmarkRepository bookmarkRepository;
  late MockBookmarkLocalRepository bookmarkLocalRepository;
  late MockSaveBookmarkedMediaItemUseCase saveBookmarkedMediaItemUseCase;
  late MockHasActiveSubscriptionUseCase hasActiveSubscriptionUseCase;

  late RunIntitialBookmarkSyncUseCase useCase;

  setUp(() {
    bookmarkRepository = MockBookmarkRepository();
    bookmarkLocalRepository = MockBookmarkLocalRepository();
    saveBookmarkedMediaItemUseCase = MockSaveBookmarkedMediaItemUseCase();
    hasActiveSubscriptionUseCase = MockHasActiveSubscriptionUseCase();

    useCase = RunIntitialBookmarkSyncUseCase(
      bookmarkRepository,
      bookmarkLocalRepository,
      saveBookmarkedMediaItemUseCase,
      hasActiveSubscriptionUseCase,
    );
  });

  test('should not run when user has no active subscription', () async {
    when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => false);

    await useCase();

    verifyNever(bookmarkLocalRepository.loadLastSynchronizationTime());
  });

  test('should not run when user has already synced bookmarks', () async {
    when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => true);
    when(bookmarkLocalRepository.loadLastSynchronizationTime()).thenAnswer((_) async => DateTime.now());

    await useCase();

    verifyNever(
      bookmarkRepository.getPaginatedBookmarks(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
        filter: anyNamed('filter'),
        order: anyNamed('order'),
        sort: anyNamed('sort'),
      ),
    );
  });

  test('should run when force is true', () async {
    when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => true);
    when(bookmarkLocalRepository.loadLastSynchronizationTime()).thenAnswer((_) async => DateTime.now());
    when(bookmarkLocalRepository.getAllIds()).thenAnswer((_) async => []);
    when(
      bookmarkRepository.getPaginatedBookmarks(
        limit: anyNamed('limit'),
        offset: 0,
        filter: anyNamed('filter'),
        order: anyNamed('order'),
        sort: anyNamed('sort'),
      ),
    ).thenAnswer(
      (_) async => [],
    );

    await useCase(force: true);

    verify(
      bookmarkRepository.getPaginatedBookmarks(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
        filter: anyNamed('filter'),
        order: anyNamed('order'),
        sort: anyNamed('sort'),
      ),
    );
  });

  test('should run if user has active subscription and has not synced bookmarks', () async {
    when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => true);
    when(bookmarkLocalRepository.loadLastSynchronizationTime()).thenAnswer((_) async => null);
    when(bookmarkLocalRepository.getAllIds()).thenAnswer((_) async => []);
    when(
      bookmarkRepository.getPaginatedBookmarks(
        limit: anyNamed('limit'),
        offset: 0,
        filter: anyNamed('filter'),
        order: anyNamed('order'),
        sort: anyNamed('sort'),
      ),
    ).thenAnswer(
      (_) async => [],
    );

    await useCase();

    verify(
      bookmarkRepository.getPaginatedBookmarks(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
        filter: anyNamed('filter'),
        order: anyNamed('order'),
        sort: anyNamed('sort'),
      ),
    );
  });

  test('should save all fetched bookmarks', () async {
    final bookmarks = [
      Bookmark('000', BookmarkData.article(TestData.article)),
      Bookmark('001', BookmarkData.article(TestData.article)),
    ];

    when(hasActiveSubscriptionUseCase()).thenAnswer((_) async => true);
    when(bookmarkLocalRepository.loadLastSynchronizationTime()).thenAnswer((_) async => null);
    when(
      bookmarkRepository.getPaginatedBookmarks(
        limit: anyNamed('limit'),
        offset: 0,
        filter: anyNamed('filter'),
        order: anyNamed('order'),
        sort: anyNamed('sort'),
      ),
    ).thenAnswer((_) async => bookmarks);

    await useCase();

    verify(
      bookmarkRepository.getPaginatedBookmarks(
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
        filter: anyNamed('filter'),
        order: anyNamed('order'),
        sort: anyNamed('sort'),
      ),
    );

    verify(saveBookmarkedMediaItemUseCase.usingBookmarkList(bookmarks));
  });
}
