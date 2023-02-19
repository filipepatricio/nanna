import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:better_informed_mobile/domain/article/data/update_article_progress_response.dart';
import 'package:better_informed_mobile/domain/article/use_case/synchroniza_article_progress_with_remote_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../generated_mocks.mocks.dart';
import '../../../../test_data.dart';

void main() {
  late MockArticleRepository articleRepository;
  late MockUpdateArticleProgressStateNotifierUseCase updateArticleProgressStateNotifierUseCase;
  late SynchronizaArticleProgressWithRemoteUseCase useCase;

  setUp(() {
    articleRepository = MockArticleRepository();
    updateArticleProgressStateNotifierUseCase = MockUpdateArticleProgressStateNotifierUseCase();

    useCase = SynchronizaArticleProgressWithRemoteUseCase(
      articleRepository,
      updateArticleProgressStateNotifierUseCase,
    );
  });

  test('marks itself as synced and expired on successful api call', () async {
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

    when(articleRepository.getArticleHeader(article.slug)).thenAnswer((realInvocation) async => article);
    when(articleRepository.trackReadingProgress(synchronizable.dataId, progress.contentProgress))
        .thenAnswer((realInvocation) async => updatedProgress);
    when(updateArticleProgressStateNotifierUseCase(article)).thenAnswer((realInvocation) {});

    final result = await useCase(synchronizable);

    expect(result, isA<Synchronized<ArticleProgress>>());
    expect(result.expirationDate, result.createdAt);

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

    expect(useCase(synchronizable), throwsA(exception));
  });
}
