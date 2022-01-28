import 'package:better_informed_mobile/data/article/api/dto/publisher_dto.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/image_dto.dart';
import 'package:better_informed_mobile/data/topic/api/dto/reading_list_dto.dart';
import 'package:better_informed_mobile/data/topic/api/dto/summary_card_dto.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_owner_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topic_dto.g.dart';

@JsonSerializable()
class TopicDTO {
  final String id;
  final String title;
  final String strippedTitle;
  final String introduction;
  final TopicOwnerDTO owner;
  final String lastUpdatedAt;
  final List<PublisherDTO> highlightedPublishers;
  final ImageDTO heroImage;
  final ImageDTO coverImage;
  final ReadingListDTO readingList;
  final List<SummaryCardDTO> summaryCards;

  TopicDTO(
    this.id,
    this.title,
    this.strippedTitle,
    this.introduction,
    this.owner,
    this.lastUpdatedAt,
    this.highlightedPublishers,
    this.heroImage,
    this.coverImage,
    this.readingList,
    this.summaryCards,
  );

  factory TopicDTO.fromJson(Map<String, dynamic> json) => _$TopicDTOFromJson(json);

  Map<String, dynamic> toJson() => _$TopicDTOToJson(this);
}
