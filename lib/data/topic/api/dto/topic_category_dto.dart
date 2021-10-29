import 'package:json_annotation/json_annotation.dart';
part 'topic_category_dto.g.dart';

@JsonSerializable()
class TopicCategoryDTO {
  final String name;

  TopicCategoryDTO(this.name);

  factory TopicCategoryDTO.fromJson(Map<String, dynamic> json) => _$TopicCategoryDTOFromJson(json);

  Map<String, dynamic> toJson() => _$TopicCategoryDTOToJson(this);
}
