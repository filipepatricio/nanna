import 'package:better_informed_mobile/domain/article/data/audio_file.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_playback_state.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';

abstract class AudioRepository {
  Future<void> prepareItem(AudioItem item, AudioFile audioFile, MediaItemArticle article);

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
