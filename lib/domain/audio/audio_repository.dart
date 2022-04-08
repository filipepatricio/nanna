import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_playback_state.dt.dart';

abstract class AudioRepository {
  Future<void> prepareItem(AudioItem item);

  Future<void> closeItem();

  Future<void> play();

  Future<void> pause();

  Future<void> seek(Duration position);

  Future<void> fastForward();

  Future<void> rewind();

  Future<void> changeAudioSpeed(double speed);

  Stream<AudioPlaybackState> get playbackState;

  Stream<Duration> get position;
}
