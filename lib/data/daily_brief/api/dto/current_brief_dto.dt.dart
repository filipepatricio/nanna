import 'package:better_informed_mobile/data/daily_brief/api/dto/current_brief_introduction_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/headline_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'current_brief_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class CurrentBriefDTO {
  CurrentBriefDTO(
    this.id,
    this.greeting,
    this.introduction,
    this.goodbye,
    this.topics,
    this.numberOfTopics,
    this.date,
  );

  final String id;
  final HeadlineDTO greeting;
  final CurrentBriefIntroductionDTO? introduction;
  final HeadlineDTO goodbye;
  final List<TopicDTO> topics;
  final int numberOfTopics;
  final String date;

  factory CurrentBriefDTO.fromJson(Map<String, dynamic> json) => _$CurrentBriefDTOFromJson(json);
}
