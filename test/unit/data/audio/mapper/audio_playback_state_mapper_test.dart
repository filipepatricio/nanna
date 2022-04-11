import 'package:audio_service/audio_service.dart';
import 'package:better_informed_mobile/data/audio/handler/current_audio_item_dto.dt.dart';
import 'package:better_informed_mobile/data/audio/mapper/audio_item_mapper.di.dart';
import 'package:better_informed_mobile/data/audio/mapper/audio_playback_state_mapper.di.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_playback_state.dt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'audio_playback_state_mapper_test.mocks.dart';

@GenerateMocks(
  [
    AudioItemMapper,
  ],
)
void main() {
  late MockAudioItemMapper audioItemMapper;
  late AudioPlaybackStateMapper mapper;

  setUp(() {
    audioItemMapper = MockAudioItemMapper();
    mapper = AudioPlaybackStateMapper(audioItemMapper);
  });

  test('returns not initialized state', () {
    final original = CurrentAudioItemDTO(
      state: PlaybackState(
        processingState: AudioProcessingState.idle,
      ),
    );
    const expected = AudioPlaybackState.notInitialized();

    final actual = mapper(original);

    expect(actual, expected);
  });

  group('returns loading state', () {
    test('for loading audio state', () {
      const mediaItem = MediaItem(
        id: '0000',
        title: 'Title',
      );
      final state = PlaybackState(
        processingState: AudioProcessingState.loading,
        speed: 1.0,
      );
      final original = CurrentAudioItemDTO(
        state: state,
        mediaItem: mediaItem,
      );
      const expected = AudioPlaybackState.loading(speed: 1.0);

      final actual = mapper(original);

      expect(actual, expected);
    });

    test('for buffering audio state', () {
      const mediaItem = MediaItem(
        id: '0000',
        title: 'Title',
      );
      final state = PlaybackState(
        processingState: AudioProcessingState.buffering,
        speed: 1.0,
      );
      final original = CurrentAudioItemDTO(
        state: state,
        mediaItem: mediaItem,
      );
      const expected = AudioPlaybackState.loading(speed: 1.0);

      final actual = mapper(original);

      expect(actual, expected);
    });

    test('for ready state when duration is null', () {
      const mediaItem = MediaItem(
        id: '0000',
        title: 'Title',
      );
      final state = PlaybackState(
        processingState: AudioProcessingState.ready,
        speed: 1.0,
        playing: true,
      );
      final original = CurrentAudioItemDTO(
        state: state,
        mediaItem: mediaItem,
      );
      final audioItem = AudioItem(
        id: 'id',
        title: 'title',
        author: 'author',
        imageUrl: 'imageUrl',
      );
      const expected = AudioPlaybackState.loading(
        speed: 1.0,
      );

      when(audioItemMapper.to(mediaItem)).thenAnswer((realInvocation) => audioItem);

      final actual = mapper(original);

      expect(actual, expected);
    });
  });

  test('returns playing state', () {
    const mediaItem = MediaItem(
      id: '0000',
      title: 'Title',
      duration: Duration(seconds: 1),
    );
    final state = PlaybackState(
      processingState: AudioProcessingState.ready,
      speed: 1.0,
      playing: true,
    );
    final original = CurrentAudioItemDTO(
      state: state,
      mediaItem: mediaItem,
    );
    final audioItem = AudioItem(
      id: 'id',
      title: 'title',
      author: 'author',
      imageUrl: 'imageUrl',
    );
    final expected = AudioPlaybackState.playing(
      duration: const Duration(seconds: 1),
      speed: 1.0,
      audioItem: audioItem,
    );

    when(audioItemMapper.to(mediaItem)).thenAnswer((realInvocation) => audioItem);

    final actual = mapper(original);

    expect(actual, expected);
  });

  test('returns paused state', () {
    const mediaItem = MediaItem(
      id: '0000',
      title: 'Title',
      duration: Duration(seconds: 1),
    );
    final state = PlaybackState(
      processingState: AudioProcessingState.ready,
      speed: 1.0,
      playing: false,
    );
    final original = CurrentAudioItemDTO(
      state: state,
      mediaItem: mediaItem,
    );
    final audioItem = AudioItem(
      id: 'id',
      title: 'title',
      author: 'author',
      imageUrl: 'imageUrl',
    );
    final expected = AudioPlaybackState.paused(
      duration: const Duration(seconds: 1),
      speed: 1.0,
      audioItem: audioItem,
    );

    when(audioItemMapper.to(mediaItem)).thenAnswer((realInvocation) => audioItem);

    final actual = mapper(original);

    expect(actual, expected);
  });

  test('returns completed state', () {
    const mediaItem = MediaItem(
      id: '0000',
      title: 'Title',
      duration: Duration(seconds: 1),
    );
    final state = PlaybackState(
      processingState: AudioProcessingState.completed,
      speed: 1.0,
      playing: false,
    );
    final original = CurrentAudioItemDTO(
      state: state,
      mediaItem: mediaItem,
    );
    final audioItem = AudioItem(
      id: 'id',
      title: 'title',
      author: 'author',
      imageUrl: 'imageUrl',
    );
    final expected = AudioPlaybackState.completed(
      duration: const Duration(seconds: 1),
      speed: 1.0,
      audioItem: audioItem,
    );

    when(audioItemMapper.to(mediaItem)).thenAnswer((realInvocation) => audioItem);

    final actual = mapper(original);

    expect(actual, expected);
  });
}
