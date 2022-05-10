import 'package:better_informed_mobile/data/article/api/dto/article_header_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_preview_dto.dt.dart';
import 'package:better_informed_mobile/data/util/dto_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_content_area_dto.dt.freezed.dart';
part 'explore_content_area_dto.dt.g.dart';

@Freezed(unionKey: '__typename', fallbackUnion: unknownKey)
class ExploreContentAreaDTO with _$ExploreContentAreaDTO {
  @FreezedUnionValue('ArticlesExploreArea')
  factory ExploreContentAreaDTO.articles(
    String id,
    String name,
    String description,
    List<ArticleHeaderDTO> articles,
  ) = _ExploreContentAreaDTOArticles;

  @FreezedUnionValue('TopicsExploreArea')
  factory ExploreContentAreaDTO.topics(
    String id,
    String name,
    List<TopicPreviewDTO> topics,
  ) = _ExploreContentAreaDTOTopics;

  @FreezedUnionValue('SmallTopicsExploreArea')
  factory ExploreContentAreaDTO.smallTopics(
    String id,
    String name,
    String description,
    List<TopicPreviewDTO> topics,
  ) = _ExploreContentAreaDTOSmallTopics;

  @FreezedUnionValue('HighlightedTopicsExploreArea')
  factory ExploreContentAreaDTO.highlightedTopics(
    String id,
    String name,
    String description,
    String backgroundColor,
    List<TopicPreviewDTO> topics,
  ) = _ExploreContentAreaDTOHighlightedTopics;

  @FreezedUnionValue(unknownKey)
  factory ExploreContentAreaDTO.unknown(String id) = _ExploreContentAreaDTOUnknown;

  factory ExploreContentAreaDTO.fromJson(Map<String, dynamic> json) => _$ExploreContentAreaDTOFromJson(json);
}
