import 'package:better_informed_mobile/data/audio/handler/informed_audio_handler.dart';
import 'package:better_informed_mobile/domain/audio/exception/unknown_audio_file_duration_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../test_data.dart';

void main() {
  test('sets up listener on succesful audio load', () async {
    final informedAudioHandler = InformedAudioHandler(FakeAudioPlayer());
    await expectLater(informedAudioHandler.open(TestData.premiumArticleWithAudio.url), completes);
  });

  test('throws exception on unknown audio duration', () async {
    final informedAudioHandler = InformedAudioHandler(FakeAudioPlayerFail());
    await expectLater(informedAudioHandler.open('fail-url'), throwsA(isA<AudioFileUnknownDurationException>()));
  });
}

class FakeAudioPlayer extends Fake implements AudioPlayer {
  @override
  Future<Duration?> setFilePath(String filePath, {Duration? initialPosition, bool preload = true}) async {
    return const Duration(seconds: 1);
  }

  @override
  Stream<PlaybackEvent> get playbackEventStream => Stream.value(PlaybackEvent());
}

class FakeAudioPlayerFail extends Fake implements AudioPlayer {
  @override
  Future<Duration?> setFilePath(String filePath, {Duration? initialPosition, bool preload = true}) async => null;
}
