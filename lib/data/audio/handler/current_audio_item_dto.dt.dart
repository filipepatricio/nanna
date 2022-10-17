import 'package:audio_service/audio_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_audio_item_dto.dt.freezed.dart';

@Freezed(toJson: false)
class CurrentAudioItemDTO with _$CurrentAudioItemDTO {
  factory CurrentAudioItemDTO({
    required PlaybackState state,
    MediaItem? mediaItem,
  }) = _CurrentAudioItemDTO;
}
