import 'package:better_informed_mobile/data/article/api/dto/article_dto.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_content_area_dto.freezed.dart';

part 'explore_content_area_dto.g.dart';

const _unknownKey = 'unknown';

@Freezed(unionKey: '__typename', fallbackUnion: _unknownKey)
class ExploreContentAreaDTO with _$ExploreContentAreaDTO {
  @FreezedUnionValue('ArticlesExploreArea')
  factory ExploreContentAreaDTO.articles(
    String id,
    String name,
    List<ArticleDTO> articles,
  ) = _ExploreContentAreaDTOArticles;

  @FreezedUnionValue('ArticlesWithFeatureExploreArea')
  factory ExploreContentAreaDTO.articlesWithFeature(
    String id,
    String name,
    String backgroundColor,
    List<ArticleDTO> articles,
  ) = _ExploreContentAreaDTOArticlesWithFeature;

  @FreezedUnionValue('TopicsExploreArea')
  factory ExploreContentAreaDTO.topics(
    String id,
    String name,
    List<TopicDTO> topics,
  ) = _ExploreContentAreaDTOTopics;

  @FreezedUnionValue(_unknownKey)
  factory ExploreContentAreaDTO.unknown() = _ExploreContentAreaDTOUnknown;

  factory ExploreContentAreaDTO.fromJson(Map<String, dynamic> json) => _$ExploreContentAreaDTOFromJson(json);
}
