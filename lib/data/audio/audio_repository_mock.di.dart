import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_playback_state.dt.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

@LazySingleton(as: AudioRepository, env: mockEnvs)
class AudioRepositoryMock implements AudioRepository {
  final BehaviorSubject<AudioPlaybackState> _playbackState =
      BehaviorSubject.seeded(const AudioPlaybackState.notInitialized());

  @override
  Future<void> closeItem() async {
    _playbackState.add(const AudioPlaybackState.notInitialized());
  }

  @override
  Future<void> prepareItem(AudioItem item) async {
    _playbackState.add(const AudioPlaybackState.loading(speed: 1.0));
    _playbackState.add(
      const AudioPlaybackState.paused(
        duration: Duration(seconds: 120),
        speed: 1.0,
      ),
    );
  }

  @override
  Future<void> pause() async {
    _playbackState.add(
      const AudioPlaybackState.paused(
        duration: Duration(seconds: 120),
        speed: 1.0,
      ),
    );
  }

  @override
  Future<void> play() async {
    _playbackState.add(
      const AudioPlaybackState.playing(
        duration: Duration(seconds: 120),
        speed: 1.0,
      ),
    );
  }

  @override
  Stream<AudioPlaybackState> get playbackState => _playbackState.stream;

  @override
  Stream<Duration> get position => Stream.value(const Duration(seconds: 10));

  @override
  Future<void> seek(Duration seekDuration) async {}

  @override
  Future<void> fastForward() async {}

  @override
  Future<void> rewind() async {}

  @override
  Future<void> changeAudioSpeed(double speed) async {}
}
