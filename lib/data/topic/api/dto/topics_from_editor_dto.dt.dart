import 'package:better_informed_mobile/data/topic/api/dto/topic_preview_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topics_from_editor_dto.dt.g.dart';

@JsonSerializable()
class TopicsFromEditorDTO {
  TopicsFromEditorDTO(this.topics);

  factory TopicsFromEditorDTO.fromJson(Map<String, dynamic> json) => _$TopicsFromEditorDTOFromJson(json);
  @JsonKey(name: 'getTopicsFromEditor')
  final List<TopicPreviewDTO> topics;

  Map<String, dynamic> toJson() => _$TopicsFromEditorDTOToJson(this);
}
