import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topics_from_editor_dto.dt.g.dart';

@JsonSerializable()
class TopicsFromEditorDTO {
  @JsonKey(name: 'getTopicsFromEditor')
  final List<TopicDTO> topics;

  TopicsFromEditorDTO(this.topics);

  factory TopicsFromEditorDTO.fromJson(Map<String, dynamic> json) => _$TopicsFromEditorDTOFromJson(json);

  Map<String, dynamic> toJson() => _$TopicsFromEditorDTOToJson(this);
}
