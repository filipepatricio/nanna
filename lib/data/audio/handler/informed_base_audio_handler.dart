import 'package:audio_service/audio_service.dart';
import 'package:better_informed_mobile/data/audio/handler/current_audio_item_dto.dt.dart';

abstract class InformedBaseAudioHandler extends BaseAudioHandler {
  Future<void> initialize();

  Future<void> notifyLoading(MediaItem item);

  Future<Duration> open(String path);

  Stream<CurrentAudioItemDTO> get currentAudioItemStream;
}
