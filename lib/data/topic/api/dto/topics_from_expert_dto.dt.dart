import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topics_from_expert_dto.dt.g.dart';

@JsonSerializable()
class TopicsFromExpertDTO {
  // The key getTopicsFromExpert has a List of topics as a value, so I can't handle the topics if I consider getTopicsFromExpert just as a rootKey instead of a common key as this
  @JsonKey(name: 'getTopicsFromExpert')
  final List<TopicDTO> topics;

  TopicsFromExpertDTO(this.topics);

  factory TopicsFromExpertDTO.fromJson(Map<String, dynamic> json) => _$TopicsFromExpertDTOFromJson(json);

  Map<String, dynamic> toJson() => _$TopicsFromExpertDTOToJson(this);
}
