import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/audio_file.dart';
import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:better_informed_mobile/domain/audio/exception/file_access_expired.dart';
import 'package:better_informed_mobile/domain/audio/use_case/prepare_audio_track_use_case.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_data.dart';
import 'prepare_audio_track_use_case_test.mocks.dart';

@GenerateMocks(
  [
    AudioRepository,
    ArticleRepository,
  ],
)
void main() {
  late MockAudioRepository audioRepository;
  late MockArticleRepository articleRepository;
  late PrepareArticleAudioTrackUseCase useCase;

  setUp(() {
    audioRepository = MockAudioRepository();
    articleRepository = MockArticleRepository();
    useCase = PrepareArticleAudioTrackUseCase(
      audioRepository,
      articleRepository,
    );
  });

  test('successfuly prepares audio', () async {
    final article = TestData.premiumArticleWithAudio;
    final audioFile = AudioFile(url: 'url');
    const imageUrl = 'url';

    when(articleRepository.getArticleAudioFile(article.slug, any)).thenAnswer(
      (realInvocation) async => audioFile,
    );
    when(audioRepository.prepareItem(any)).thenAnswer((_) async {});

    await expectLater(
      useCase(article: article, imageUrl: imageUrl),
      completes,
    );

    verify(audioRepository.prepareItem(any));
    verify(articleRepository.getArticleAudioFile(article.slug));
  });

  test('successfuly prepares audio after expired error', () async {
    final article = TestData.premiumArticleWithAudio;
    final audioFile = AudioFile(url: 'url');
    const imageUrl = 'url';

    var invocationCounter = 0;

    when(articleRepository.getArticleAudioFile(article.slug, any)).thenAnswer(
      (realInvocation) async => audioFile,
    );
    when(audioRepository.prepareItem(any)).thenAnswer((invocation) async {
      if (invocationCounter++ == 0) {
        throw FileAccessExpired();
      }
    });

    await expectLater(
      useCase(article: article, imageUrl: imageUrl),
      completes,
    );

    verify(audioRepository.prepareItem(any)).called(2);
    verify(articleRepository.getArticleAudioFile(article.slug)).called(1);
    verify(articleRepository.getArticleAudioFile(article.slug, true)).called(1);
  });

  test('fails preparing audio on exception', () async {
    final article = TestData.premiumArticleWithAudio;
    const imageUrl = 'url';
    final exception = Exception();

    when(articleRepository.getArticleAudioFile(article.slug)).thenAnswer(
      (realInvocation) async => throw exception,
    );

    await expectLater(
      useCase(article: article, imageUrl: imageUrl),
      throwsA(exception),
    );

    verifyNever(audioRepository.prepareItem(any));
    verify(articleRepository.getArticleAudioFile(article.slug)).called(1);
  });
}
