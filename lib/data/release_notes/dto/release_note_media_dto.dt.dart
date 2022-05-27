import 'package:freezed_annotation/freezed_annotation.dart';

part 'release_note_media_dto.dt.freezed.dart';
part 'release_note_media_dto.dt.g.dart';

@Freezed(
  unionKey: 'format',
  fallbackUnion: 'unknown',
  toJson: false,
)
class ReleaseNoteMediaDTO with _$ReleaseNoteMediaDTO {
  @FreezedUnionValue('png')
  factory ReleaseNoteMediaDTO.png(String format, String url) = _ReleaseNoteMediaDTOImage;

  @FreezedUnionValue('mp4')
  factory ReleaseNoteMediaDTO.mp4(String format, String url) = _ReleaseNoteMediaDTOMP4;

  @FreezedUnionValue('unknown')
  factory ReleaseNoteMediaDTO.unknown(String format) = _ReleaseNoteMediaDTOUnknown;

  factory ReleaseNoteMediaDTO.fromJson(Map<String, dynamic> json) => _$ReleaseNoteMediaDTOFromJson(json);
}
