import 'package:audio_service/audio_service.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_playback_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class AudioPlaybackStateMapper implements Mapper<PlaybackState, AudioPlaybackState> {
  @override
  AudioPlaybackState call(PlaybackState data) {
    return AudioPlaybackState(
      playing: data.playing,
      duration: data.bufferedPosition,
    );
  }
}
