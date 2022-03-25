import 'package:better_informed_mobile/domain/audio/data/audio_item.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_playback_state.dart';

abstract class AudioRepository {
  Future<void> prepareItem(AudioItem item);

  Future<void> closeItem();

  Future<void> play();

  Future<void> pause();

  Future<void> seek(Duration position);

  Future<void> fastForward();

  Future<void> rewind();

  Stream<AudioPlaybackState> get playbackState;

  Stream<Duration> get position;
}
