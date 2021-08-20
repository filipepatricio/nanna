import 'package:better_informed_mobile/data/daily_brief/api/dto/category_dto.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/image_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topic_dto.g.dart';

@JsonSerializable()
class TopicDTO {
  final String id;
  final String title;
  final String introduction;
  final String summary;
  final CategoryDTO category;
  final ImageDTO image;

  TopicDTO(
    this.id,
    this.title,
    this.introduction,
    this.summary,
    this.category,
    this.image,
  );

  factory TopicDTO.fromJson(Map<String, dynamic> json) => _$TopicDTOFromJson(json);

  Map<String, dynamic> toJson() => _$TopicDTOToJson(this);
}
