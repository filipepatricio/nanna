import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:better_informed_mobile/domain/article/data/update_article_progress_response.dart';
import 'package:better_informed_mobile/domain/article/use_case/save_article_read_progress_locally_use_case.di.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../generated_mocks.mocks.dart';
import '../../../../test_data.dart';

void main() {
  late MockArticleLocalRepository articleLocalRepository;
  late MockArticleProgressLocalRepository articleProgressLocalRepository;
  late SaveArticleReadProgressLocallyUseCase useCase;

  setUp(() {
    articleLocalRepository = MockArticleLocalRepository();
    articleProgressLocalRepository = MockArticleProgressLocalRepository();

    useCase = SaveArticleReadProgressLocallyUseCase(
      articleLocalRepository,
      articleProgressLocalRepository,
    );
  });

  group('save article progress', () {
    test('when there is no old progress stored', () async {
      final article = TestData.article;
      const progress = 50;

      when(articleProgressLocalRepository.load(article.slug)).thenAnswer((_) async => null);
      when(articleProgressLocalRepository.save(any)).thenAnswer((_) async {});
      when(articleLocalRepository.load(any)).thenAnswer((_) async => null);

      await useCase(article.slug, progress);

      verify(articleProgressLocalRepository.save(any));
    });

    test('when there is old progress stored that is lower', () async {
      final article = TestData.article;
      final articleProgress = ArticleProgress(audioPosition: 10, audioProgress: 5, contentProgress: 45);
      const progress = 50;

      when(articleProgressLocalRepository.load(article.slug)).thenAnswer(
        (_) async => Synchronizable.createNotSynchronized(article.slug, const Duration(days: 7), articleProgress),
      );
      when(articleProgressLocalRepository.save(any)).thenAnswer((_) async {});
      when(articleLocalRepository.load(any)).thenAnswer((_) async => null);

      await useCase(article.slug, progress);

      verify(
        articleProgressLocalRepository.save(
          captureThat(
            isA<Synchronizable<ArticleProgress>>().having(
              (s) => s.data,
              'data',
              isA<ArticleProgress>()
                  .having(
                    (savedProgress) => savedProgress.contentProgress,
                    'contentProgress',
                    progress,
                  )
                  .having(
                    (savedProgress) => savedProgress.audioPosition,
                    'audioPosition',
                    articleProgress.audioPosition,
                  )
                  .having(
                    (savedProgress) => savedProgress.audioProgress,
                    'audioProgress',
                    articleProgress.audioProgress,
                  ),
            ),
          ),
        ),
      );
    });
  });

  group('do not save article progress', () {
    test('when there is old progress stored that is higher', () async {
      final article = TestData.article;
      final articleProgress = ArticleProgress(audioPosition: 0, audioProgress: 0, contentProgress: 55);
      const progress = 50;

      when(articleProgressLocalRepository.load(article.slug)).thenAnswer(
        (_) async => Synchronizable.createNotSynchronized(article.slug, const Duration(days: 7), articleProgress),
      );
      when(articleProgressLocalRepository.save(any)).thenAnswer((_) async {});
      when(articleLocalRepository.load(any)).thenAnswer((_) async => null);

      await useCase(article.slug, progress);

      verifyNever(articleProgressLocalRepository.save(any));
    });
  });

  group('return progress update', () {
    test('that is not finished when progress is under threshold', () async {
      final article = TestData.article;
      const progress = finishedArticleProgressThreshold - 1;

      when(articleProgressLocalRepository.load(article.slug)).thenAnswer((_) async => null);
      when(articleProgressLocalRepository.save(any)).thenAnswer((_) async {});
      when(articleLocalRepository.load(any)).thenAnswer((_) async => null);

      final result = await useCase(article.slug, progress);

      expect(
        result,
        isA<UpdateArticleProgressResponse>()
            .having(
              (response) => response.progressState,
              'progressState',
              ArticleProgressState.inProgress,
            )
            .having(
              (response) => response.progress,
              'progress',
              isA<ArticleProgress>().having(
                (articleProgress) => articleProgress.contentProgress,
                'contentProgress',
                progress,
              ),
            ),
      );
    });
    test('that is finished when progress is over threshold', () async {
      final article = TestData.article;
      final articleProgress = ArticleProgress(audioPosition: 0, audioProgress: 0, contentProgress: 45);
      const progress = finishedArticleProgressThreshold + 1;

      when(articleProgressLocalRepository.load(article.slug)).thenAnswer(
        (_) async => Synchronizable.createNotSynchronized(article.slug, const Duration(days: 7), articleProgress),
      );
      when(articleProgressLocalRepository.save(any)).thenAnswer((_) async {});
      when(articleLocalRepository.load(any)).thenAnswer((_) async => null);

      final result = await useCase(article.slug, progress);

      expect(
        result,
        isA<UpdateArticleProgressResponse>()
            .having(
              (response) => response.progressState,
              'progressState',
              ArticleProgressState.finished,
            )
            .having(
              (response) => response.progress,
              'progress',
              isA<ArticleProgress>().having(
                (articleProgress) => articleProgress.contentProgress,
                'contentProgress',
                progress,
              ),
            ),
      );
    });
  });

  group('updates stored locally article', () {
    test('when progress is over threshold', () async {
      final article = TestData.fullArticle.copyWith(
        metadata: TestData.article.copyWith(
          progress: ArticleProgress(audioPosition: 0, audioProgress: 0, contentProgress: 10),
          progressState: ArticleProgressState.unread,
        ),
      );
      final syncArticle = Synchronizable.createSynchronized(
        article,
        article.metadata.slug,
        const Duration(days: 7),
      );
      final articleProgress = ArticleProgress(audioPosition: 0, audioProgress: 0, contentProgress: 45);
      const progress = finishedArticleProgressThreshold + 1;

      when(articleProgressLocalRepository.load(article.metadata.slug)).thenAnswer(
        (_) async =>
            Synchronizable.createNotSynchronized(article.metadata.slug, const Duration(days: 7), articleProgress),
      );
      when(articleProgressLocalRepository.save(any)).thenAnswer((_) async {});
      when(articleLocalRepository.load(article.metadata.slug)).thenAnswer((_) async => syncArticle);

      await useCase(article.metadata.slug, progress);

      verify(
        articleLocalRepository.save(
          captureThat(
            isA<Synchronizable<Article>>().having(
              (synchronizable) => synchronizable.data,
              'data',
              isA<Article>().having(
                (savedArticle) => savedArticle.metadata.progressState,
                'metadata.progressState',
                ArticleProgressState.finished,
              ),
            ),
          ),
        ),
      );
    });

    test('when progress is under threshold', () async {
      final article = TestData.fullArticle.copyWith(
        metadata: TestData.article.copyWith(
          progress: ArticleProgress(audioPosition: 0, audioProgress: 0, contentProgress: 10),
          progressState: ArticleProgressState.unread,
        ),
      );
      final syncArticle = Synchronizable.createSynchronized(
        article,
        article.metadata.slug,
        const Duration(days: 7),
      );
      const progress = finishedArticleProgressThreshold - 5;

      when(articleProgressLocalRepository.load(article.metadata.slug)).thenAnswer((_) async => null);
      when(articleProgressLocalRepository.save(any)).thenAnswer((_) async {});
      when(articleLocalRepository.load(article.metadata.slug)).thenAnswer((_) async => syncArticle);

      await useCase(article.metadata.slug, progress);

      verify(
        articleLocalRepository.save(
          captureThat(
            isA<Synchronizable<Article>>().having(
              (synchronizable) => synchronizable.data,
              'data',
              isA<Article>().having(
                (savedArticle) => savedArticle.metadata.progressState,
                'metadata.progressState',
                ArticleProgressState.inProgress,
              ),
            ),
          ),
        ),
      );
    });
  });

  group('does not update local article', () {
    test('when there is no article stored locally', () async {
      final article = TestData.fullArticle.copyWith(
        metadata: TestData.article.copyWith(
          progress: ArticleProgress(audioPosition: 0, audioProgress: 0, contentProgress: 10),
          progressState: ArticleProgressState.unread,
        ),
      );
      const progress = 55;

      when(articleProgressLocalRepository.load(article.metadata.slug)).thenAnswer((_) async => null);
      when(articleProgressLocalRepository.save(any)).thenAnswer((_) async {});
      when(articleLocalRepository.load(article.metadata.slug)).thenAnswer((_) async => null);

      await useCase(article.metadata.slug, progress);

      verifyNever(articleLocalRepository.save(any));
    });

    test('when there stored article is not synchronized', () async {
      final article = TestData.fullArticle.copyWith(
        metadata: TestData.article.copyWith(
          progress: ArticleProgress(audioPosition: 0, audioProgress: 0, contentProgress: 10),
          progressState: ArticleProgressState.unread,
        ),
      );
      final syncArticle = Synchronizable.createNotSynchronized<Article>(
        article.metadata.slug,
        const Duration(days: 7),
      );
      const progress = 55;

      when(articleProgressLocalRepository.load(article.metadata.slug)).thenAnswer((_) async => null);
      when(articleProgressLocalRepository.save(any)).thenAnswer((_) async {});
      when(articleLocalRepository.load(article.metadata.slug)).thenAnswer((_) async => syncArticle);

      await useCase(article.metadata.slug, progress);

      verifyNever(articleLocalRepository.save(any));
    });
  });
}
