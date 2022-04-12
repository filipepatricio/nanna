import 'package:json_annotation/json_annotation.dart';

part 'image_dto.dt.g.dart';

@JsonSerializable()
class ImageDTO {
  final String publicId;
  final String? caption;

  ImageDTO(
    this.publicId, {
    this.caption,
  });

  factory ImageDTO.fromJson(Map<String, dynamic> json) => _$ImageDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ImageDTOToJson(this);
}
