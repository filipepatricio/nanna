import 'package:audio_service/audio_service.dart';
import 'package:better_informed_mobile/data/audio/mapper/audio_playback_state_mapper.di.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_playback_state.dt.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AudioPlaybackStateMapper mapper;

  setUp(() {
    mapper = AudioPlaybackStateMapper();
  });

  test('returns not initialized state', () {
    final original = PlaybackState(processingState: AudioProcessingState.idle);
    const expected = AudioPlaybackState.notInitialized();

    final actual = mapper(original);

    expect(actual, expected);
  });

  group('returns loading state', () {
    test('for loading audio state', () {
      final original = PlaybackState(
        processingState: AudioProcessingState.loading,
        speed: 1.0,
      );
      const expected = AudioPlaybackState.loading(speed: 1.0);

      final actual = mapper(original);

      expect(actual, expected);
    });

    test('for buffering audio state', () {
      final original = PlaybackState(
        processingState: AudioProcessingState.buffering,
        speed: 1.0,
      );
      const expected = AudioPlaybackState.loading(speed: 1.0);

      final actual = mapper(original);

      expect(actual, expected);
    });
  });

  test('returns playing state', () {
    final original = PlaybackState(
      processingState: AudioProcessingState.ready,
      speed: 1.0,
      bufferedPosition: const Duration(),
      playing: true,
    );
    const expected = AudioPlaybackState.playing(
      duration: Duration(),
      speed: 1.0,
    );

    final actual = mapper(original);

    expect(actual, expected);
  });

  test('returns paused state', () {
    final original = PlaybackState(
      processingState: AudioProcessingState.ready,
      speed: 1.0,
      bufferedPosition: const Duration(),
      playing: false,
    );
    const expected = AudioPlaybackState.paused(
      duration: Duration(),
      speed: 1.0,
    );

    final actual = mapper(original);

    expect(actual, expected);
  });

  test('returns completed state', () {
    final original = PlaybackState(
      processingState: AudioProcessingState.completed,
      speed: 1.0,
      bufferedPosition: const Duration(),
      playing: false,
    );
    const expected = AudioPlaybackState.completed(
      duration: Duration(),
      speed: 1.0,
    );

    final actual = mapper(original);

    expect(actual, expected);
  });
}
