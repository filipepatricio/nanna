import 'package:better_informed_mobile/data/image/api/dto/image_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'publisher_dto.dt.g.dart';

@JsonSerializable()
class PublisherDTO {
  PublisherDTO(
    this.name,
    this.darkLogo,
    this.lightLogo,
  );

  factory PublisherDTO.fromJson(Map<String, dynamic> json) => _$PublisherDTOFromJson(json);
  final String name;
  final ImageDTO? darkLogo;
  final ImageDTO? lightLogo;

  Map<String, dynamic> toJson() => _$PublisherDTOToJson(this);
}
