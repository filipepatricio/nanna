import 'package:better_informed_mobile/data/daily_brief/api/dto/headline_dto.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'current_brief_dto.g.dart';

@JsonSerializable()
class CurrentBriefDTO {
  final HeadlineDTO greeting;
  final HeadlineDTO goodbye;
  final List<TopicDTO> topics;
  final int numberOfTopics;

  CurrentBriefDTO(this.greeting, this.goodbye, this.topics, this.numberOfTopics);

  factory CurrentBriefDTO.fromJson(Map<String, dynamic> json) => _$CurrentBriefDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentBriefDTOToJson(this);
}
