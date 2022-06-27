import 'package:better_informed_mobile/data/release_notes/dto/release_note_media_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'release_note_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class ReleaseNoteDTO {
  ReleaseNoteDTO({
    required this.headline,
    required this.content,
    required this.date,
    required this.media,
    required this.version,
  });

  factory ReleaseNoteDTO.fromJson(Map<String, dynamic> json) => _$ReleaseNoteDTOFromJson(json);

  final String headline;
  final String content;
  final String date;
  final List<ReleaseNoteMediaDTO> media;
  final String version;
}
