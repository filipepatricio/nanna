import 'package:json_annotation/json_annotation.dart';

part 'image_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class ImageDTO {
  ImageDTO(
    this.publicId, {
    this.caption,
  });

  factory ImageDTO.fromJson(Map<String, dynamic> json) => _$ImageDTOFromJson(json);
  final String publicId;
  final String? caption;
}
