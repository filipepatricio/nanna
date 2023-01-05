import 'package:better_informed_mobile/domain/article/data/audio_file.dart';
import 'package:better_informed_mobile/domain/audio/exception/audio_file_access_expired_exception.dart';
import 'package:better_informed_mobile/domain/audio/use_case/prepare_audio_track_use_case.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../generated_mocks.mocks.dart';
import '../../../test_data.dart';

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
    final audioFile = AudioFile(url: 'url', credits: 'credits');
    const imageUrl = 'url';

    when(articleRepository.getArticleAudioFile(article.slug, any)).thenAnswer(
      (realInvocation) async => audioFile,
    );
    when(audioRepository.prepareItem(any, audioFile, article)).thenAnswer((_) async {});

    await expectLater(
      useCase(article: article, imageUrl: imageUrl),
      completes,
    );

    verify(audioRepository.prepareItem(any, audioFile, article));
    verify(articleRepository.getArticleAudioFile(article.slug));
  });

  test('successfuly prepares audio after expired error', () async {
    final article = TestData.premiumArticleWithAudio;
    final audioFile = AudioFile(url: 'url', credits: 'credits');
    const imageUrl = 'url';

    var invocationCounter = 0;

    when(articleRepository.getArticleAudioFile(article.slug, any)).thenAnswer(
      (realInvocation) async => audioFile,
    );
    when(audioRepository.prepareItem(any, audioFile, article)).thenAnswer((invocation) async {
      if (invocationCounter++ == 0) {
        throw AudioFileAccessExpiredException();
      }
    });

    await expectLater(
      useCase(article: article, imageUrl: imageUrl),
      completes,
    );

    verify(audioRepository.prepareItem(any, audioFile, article)).called(2);
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

    verifyNever(audioRepository.prepareItem(any, any, any));
    verify(articleRepository.getArticleAudioFile(article.slug)).called(1);
  });
}
