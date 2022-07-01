import 'package:json_annotation/json_annotation.dart';

part 'image_dto.dt.g.dart';

@JsonSerializable()
class ImageDTO {
  ImageDTO(
    this.publicId, {
    this.caption,
  });

  factory ImageDTO.fromJson(Map<String, dynamic> json) => _$ImageDTOFromJson(json);
  final String publicId;
  final String? caption;

  Map<String, dynamic> toJson() => _$ImageDTOToJson(this);
}
