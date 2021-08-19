import 'package:json_annotation/json_annotation.dart';

part 'image_dto.g.dart';

@JsonSerializable()
class ImageDTO {
  final String publicId;

  ImageDTO(this.publicId);

  factory ImageDTO.fromJson(Map<String, dynamic> json) => _$ImageDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ImageDTOToJson(this);
}