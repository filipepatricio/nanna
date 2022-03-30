import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_playback_state.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AudioRepository, env: mockEnvs)
class AudioRepositoryMock implements AudioRepository {
  @override
  Future<void> closeItem() async {}

  @override
  Future<void> prepareItem(AudioItem item) async {}

  @override
  Future<void> pause() async {}

  @override
  Future<void> play() async {}

  @override
  Stream<AudioPlaybackState> get playbackState => const Stream.empty();

  @override
  Stream<Duration> get position => const Stream.empty();

  @override
  Future<void> seek(Duration seekDuration) async {}

  @override
  Future<void> fastForward() async {}

  @override
  Future<void> rewind() async {}

  @override
  Future<void> changeAudioSpeed(double speed) async {}
}
