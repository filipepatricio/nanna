import 'package:better_informed_mobile/data/daily_brief/api/dto/image_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'publisher_dto.g.dart';

@JsonSerializable()
class PublisherDTO {
  final String name;
  final ImageDTO logo;

  PublisherDTO(this.name, this.logo);

  factory PublisherDTO.fromJson(Map<String, dynamic> json) => _$PublisherDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PublisherDTOToJson(this);
}