import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:better_informed_mobile/domain/article/data/update_article_progress_response.dart';
import 'package:better_informed_mobile/domain/article/use_case/track_article_reading_progress_use_case.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../generated_mocks.mocks.dart';
import '../../../../test_data.dart';

void main() {
  late MockArticleRepository articleRepository;
  late MockUpdateArticleProgressStateNotifierUseCase updateArticleProgressStateNotifierUseCase;
  late TrackArticleReadingProgressUseCase useCase;

  setUp(() {
    articleRepository = MockArticleRepository();
    updateArticleProgressStateNotifierUseCase = MockUpdateArticleProgressStateNotifierUseCase();
    useCase = TrackArticleReadingProgressUseCase(
      articleRepository,
      updateArticleProgressStateNotifierUseCase,
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
}
