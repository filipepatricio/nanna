import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:better_informed_mobile/domain/article/data/update_article_progress_response.dart';
import 'package:better_informed_mobile/domain/article/use_case/synchroniza_article_progress_with_remote_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/exception/synchronizable_invalidated_exception.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../generated_mocks.mocks.dart';
import '../../../../../test_data.dart';

void main() {
  late MockArticleRepository articleRepository;
  late MockUpdateArticleProgressStateNotifierUseCase updateArticleProgressStateNotifierUseCase;
  late MockGetBookmarkStateUseCase getBookmarkStateUseCase;
  late MockBookmarkLocalRepository bookmarkLocalRepository;
  late SynchronizaArticleProgressWithRemoteUseCase useCase;

  setUp(() {
    articleRepository = MockArticleRepository();
    updateArticleProgressStateNotifierUseCase = MockUpdateArticleProgressStateNotifierUseCase();
    getBookmarkStateUseCase = MockGetBookmarkStateUseCase();
    bookmarkLocalRepository = MockBookmarkLocalRepository();

    useCase = SynchronizaArticleProgressWithRemoteUseCase(
      articleRepository,
      updateArticleProgressStateNotifierUseCase,
      getBookmarkStateUseCase,
      bookmarkLocalRepository,
    );
  });

  test('invalidates itself on successful api call', () async {
    final article = TestData.article;
    final progress = ArticleProgress(
      audioPosition: 5,
      audioProgress: 10,
      contentProgress: 55,
    );
    final synchronizable = Synchronizable.notSynchronized(
      data: progress,
      dataId: article.slug,
      createdAt: DateTime(2023, 02, 10),
      expirationDate: DateTime(2023, 05, 10),
    );
    final updatedProgress = UpdateArticleProgressResponse(
      progress: progress,
      progressState: ArticleProgressState.inProgress,
    );
    const bookmarkId = 'bookmarkId';

    when(articleRepository.getArticleHeader(article.slug)).thenAnswer((realInvocation) async => article);
    when(articleRepository.trackReadingProgress(synchronizable.dataId, progress.contentProgress))
        .thenAnswer((realInvocation) async => updatedProgress);
    when(updateArticleProgressStateNotifierUseCase(article)).thenAnswer((realInvocation) {});
    when(getBookmarkStateUseCase(any)).thenAnswer((realInvocation) async => BookmarkState.bookmarked(bookmarkId));
    when(bookmarkLocalRepository.load(bookmarkId)).thenAnswer(
      (realInvocation) async => Synchronizable.synchronized(
        data: Bookmark(
          bookmarkId,
          BookmarkData.article(
            article.copyWith(
              progress: ArticleProgress(
                audioPosition: 0,
                audioProgress: 0,
                contentProgress: 0,
              ),
            ),
          ),
        ),
        dataId: bookmarkId,
        createdAt: DateTime(2023, 1),
        synchronizedAt: DateTime(2023, 1),
        expirationDate: DateTime(2023, 1),
      ),
    );

    await expectLater(useCase(synchronizable, true), throwsA(isA<SynchronizableInvalidatedException>()));

    verify(
      bookmarkLocalRepository.save(
        argThat(
          isA<Synchronizable<Bookmark>>().having(
            (p0) => p0.data?.data,
            'data.data',
            BookmarkData.article(article),
          ),
        ),
      ),
    );
    verify(
      updateArticleProgressStateNotifierUseCase(
        argThat(
          isA<MediaItemArticle>()
              .having(
                (item) => item.progress.contentProgress,
                'progress.contentProgress',
                updatedProgress.progress.contentProgress,
              )
              .having((item) => item.progressState, 'progressState', updatedProgress.progressState),
        ),
      ),
    );
  });

  test('does not change state on failed api call', () async {
    final progress = ArticleProgress(
      audioPosition: 5,
      audioProgress: 10,
      contentProgress: 55,
    );
    final synchronizable = Synchronizable.notSynchronized(
      data: progress,
      dataId: 'id',
      createdAt: DateTime(2023, 02, 10),
      expirationDate: DateTime(2023, 05, 10),
    );
    final exception = Exception();

    when(articleRepository.trackReadingProgress(synchronizable.dataId, progress.contentProgress))
        .thenAnswer((realInvocation) async => throw exception);

    expect(useCase(synchronizable, true), throwsA(exception));
  });
}
