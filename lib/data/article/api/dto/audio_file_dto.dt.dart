import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_file_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class AudioFileDTO {
  AudioFileDTO(
    this.url,
    this.credits,
  );

  factory AudioFileDTO.fromJson(Map<String, dynamic> json) => _$AudioFileDTOFromJson(json);

  final String url;
  final String? credits;
}
