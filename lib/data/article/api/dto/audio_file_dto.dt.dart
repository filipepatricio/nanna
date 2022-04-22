import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_file_dto.dt.g.dart';

@JsonSerializable()
class AudioFileDTO {
  final String url;
  final String? credits;

  AudioFileDTO(
    this.url,
    this.credits,
  );

  factory AudioFileDTO.fromJson(Map<String, dynamic> json) => _$AudioFileDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AudioFileDTOToJson(this);
}
