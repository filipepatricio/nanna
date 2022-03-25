import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item_metadata.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_playback_state.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AudioRepository, env: mockEnvs)
class AudioRepositoryMock implements AudioRepository {
  @override
  Future<void> closeItem() {
    // TODO: implement closeCurrentItem
    throw UnimplementedError();
  }

  @override
  Future<AudioItemMetadata> prepareItem(AudioItem item) {
    // TODO: implement openItem
    throw UnimplementedError();
  }

  @override
  Future<void> pause() {
    // TODO: implement pause
    throw UnimplementedError();
  }

  @override
  Future<void> play() {
    // TODO: implement play
    throw UnimplementedError();
  }

  @override
  // TODO: implement progress
  Stream<AudioPlaybackState> get playbackState => throw UnimplementedError();

  @override
  // TODO: implement position
  Stream<Duration> get position => throw UnimplementedError();

  @override
  Future<void> seek(Duration seekDuration) {
    // TODO: implement seek
    throw UnimplementedError();
  }

  @override
  Future<void> fastForward() {
    // TODO: implement fastForward
    throw UnimplementedError();
  }

  @override
  Future<void> rewind() {
    // TODO: implement rewind
    throw UnimplementedError();
  }
}
