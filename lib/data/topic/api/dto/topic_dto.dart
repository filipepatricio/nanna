import 'package:json_annotation/json_annotation.dart';

part 'topic_dto.g.dart';

@JsonSerializable()
class TopicDTO {
  final String id;
  final String title;
  final String introduction;
  final String summary;

  TopicDTO(this.id, this.title, this.introduction, this.summary);

  factory TopicDTO.fromJson(Map<String, dynamic> json) => _$TopicDTOFromJson(json);

  Map<String, dynamic> toJson() => _$TopicDTOToJson(this);
}