import 'package:better_informed_mobile/data/audio/handler/informed_audio_handler.dart';
import 'package:better_informed_mobile/domain/audio/exception/unknown_audio_file_duration_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mockito/mockito.dart';

import '../../../generated_mocks.mocks.dart';
import '../../../test_data.dart';

void main() {
  late MockAudioPlayer audioPlayer;
  late InformedAudioHandler informedAudioHandler;

  setUp(() {
    audioPlayer = MockAudioPlayer();
    informedAudioHandler = InformedAudioHandler(audioPlayer);
  });

  test('sets up listener on succesful audio load', () async {
    final audioUrl = TestData.premiumArticleWithAudio.url;

    when(audioPlayer.setFilePath(any)).thenAnswer((_) async => const Duration(minutes: 1));
    when(audioPlayer.playbackEventStream).thenAnswer((_) => Stream.value(PlaybackEvent()));

    await expectLater(informedAudioHandler.open(audioUrl), completes);

    verify(audioPlayer.setFilePath(any));
    verify(audioPlayer.playbackEventStream.listen(any));
  });

  test('throws exception on unknown audio duration', () async {
    final audioUrl = TestData.premiumArticleWithAudio.url;

    when(audioPlayer.setFilePath(null)).thenAnswer((_) async => null);

    await expectLater(informedAudioHandler.open(audioUrl), throwsA(isA<AudioFileUnknownDurationException>()));

    verifyNever(audioPlayer.playbackEventStream.listen(any));
  });
}
