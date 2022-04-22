import 'package:better_informed_mobile/data/daily_brief/api/dto/headline_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'current_brief_dto.dt.g.dart';

@JsonSerializable()
class CurrentBriefDTO {
  final String id;
  final HeadlineDTO greeting;
  final HeadlineDTO goodbye;
  final List<TopicDTO> topics;
  final int numberOfTopics;

  CurrentBriefDTO(this.id, this.greeting, this.goodbye, this.topics, this.numberOfTopics);

  factory CurrentBriefDTO.fromJson(Map<String, dynamic> json) => _$CurrentBriefDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentBriefDTOToJson(this);
}
