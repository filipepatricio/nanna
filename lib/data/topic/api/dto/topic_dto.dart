import 'package:better_informed_mobile/data/article/api/dto/publisher_dto.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/image_dto.dart';
import 'package:better_informed_mobile/data/topic/api/dto/reading_list_dto.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_category_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topic_dto.g.dart';

@JsonSerializable()
class TopicDTO {
  final String id;
  final String title;
  final String introduction;
  final String summary;
  final List<PublisherDTO>? highlightedPublisherList;
  final TopicCategoryDTO category;
  final ImageDTO heroImage;
  final ImageDTO coverImage;
  final ReadingListDTO readingList;

  TopicDTO(
    this.id,
    this.title,
    this.introduction,
    this.summary,
    this.highlightedPublisherList,
    this.category,
    this.heroImage,
    this.coverImage,
    this.readingList,
  );

  factory TopicDTO.fromJson(Map<String, dynamic> json) => _$TopicDTOFromJson(json);

  Map<String, dynamic> toJson() => _$TopicDTOToJson(this);
}
