import 'package:better_informed_mobile/data/topic/api/dto/topic_preview_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topics_from_expert_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class TopicsFromExpertDTO {
  TopicsFromExpertDTO(this.topics);

  factory TopicsFromExpertDTO.fromJson(Map<String, dynamic> json) => _$TopicsFromExpertDTOFromJson(json);
  // The key getTopicsFromExpert has a List of topics as a value, so I can't handle the topics if I consider getTopicsFromExpert just as a rootKey instead of a common key as this
  @JsonKey(name: 'getTopicsFromExpert')
  final List<TopicPreviewDTO> topics;
}
