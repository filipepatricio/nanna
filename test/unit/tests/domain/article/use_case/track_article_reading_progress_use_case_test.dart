import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:better_informed_mobile/domain/article/data/update_article_progress_response.dart';
import 'package:better_informed_mobile/domain/article/use_case/track_article_reading_progress_use_case.di.dart';
import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../generated_mocks.mocks.dart';
import '../../../../../test_data.dart';

void main() {
  late MockArticleRepository articleRepository;
  late MockUpdateArticleProgressStateNotifierUseCase updateArticleProgressStateNotifierUseCase;
  late MockSaveArticleReadProgressLocallyUseCase saveArticleReadProgressLocallyUseCase;
  late TrackArticleReadingProgressUseCase useCase;

  setUp(() {
    articleRepository = MockArticleRepository();
    updateArticleProgressStateNotifierUseCase = MockUpdateArticleProgressStateNotifierUseCase();
    saveArticleReadProgressLocallyUseCase = MockSaveArticleReadProgressLocallyUseCase();

    useCase = TrackArticleReadingProgressUseCase(
      articleRepository,
      updateArticleProgressStateNotifierUseCase,
      saveArticleReadProgressLocallyUseCase,
    );
  });

  test('calls repository with right args', () async {
    final article = TestData.article;
    const progress = 50;

    final updatedProgress = UpdateArticleProgressResponse(
      progress: ArticleProgress(audioPosition: 0, audioProgress: 0, contentProgress: progress),
      progressState: ArticleProgressState.finished,
    );

    when(articleRepository.trackReadingProgress(article.slug, progress)).thenAnswer((_) async => updatedProgress);
    when(updateArticleProgressStateNotifierUseCase(any)).thenAnswer((_) async {});

    await useCase(article, progress);

    verify(articleRepository.trackReadingProgress(article.slug, progress));
  });

  test('notifies article reading progress change', () async {
    final article = TestData.article;
    const progress = 50;

    final updatedProgress = UpdateArticleProgressResponse(
      progress: ArticleProgress(audioPosition: 0, audioProgress: 0, contentProgress: progress),
      progressState: ArticleProgressState.finished,
    );
    final updatedArticle = article.copyWith(
      progress: updatedProgress.progress,
      progressState: updatedProgress.progressState,
    );

    when(articleRepository.trackReadingProgress(article.slug, progress)).thenAnswer((_) async => updatedProgress);
    when(updateArticleProgressStateNotifierUseCase(updatedArticle)).thenAnswer((_) async {});

    await useCase(article, progress);

    verify(updateArticleProgressStateNotifierUseCase(updatedArticle));
  });

  test('saves progress to local storage when NoInternetConnectionException is thrown', () async {
    final article = TestData.article;
    const progress = 80;

    final updatedProgress = UpdateArticleProgressResponse(
      progress: ArticleProgress(audioPosition: 0, audioProgress: 0, contentProgress: progress),
      progressState: ArticleProgressState.finished,
    );
    final updatedArticle = article.copyWith(
      progress: updatedProgress.progress,
      progressState: updatedProgress.progressState,
    );

    when(articleRepository.trackReadingProgress(article.slug, progress)).thenThrow(NoInternetConnectionException());
    when(saveArticleReadProgressLocallyUseCase(article.slug, progress)).thenAnswer((_) async => updatedProgress);
    when(updateArticleProgressStateNotifierUseCase(updatedArticle)).thenAnswer((_) async {});

    await useCase(article, progress);

    verify(updateArticleProgressStateNotifierUseCase(updatedArticle));
    verify(saveArticleReadProgressLocallyUseCase(article.slug, progress));
  });

  test('throws on any other exception', () async {
    final article = TestData.article;
    const progress = 80;

    when(articleRepository.trackReadingProgress(article.slug, progress)).thenThrow(Exception());

    expect(useCase(article, progress), throwsException);
  });
}
