import 'package:better_informed_mobile/data/article/api/dto/article_dto.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_content_section_dto.freezed.dart';
part 'explore_content_section_dto.g.dart';

const _unknownKey = 'unknown';

@Freezed(unionKey: '__typename', fallbackUnion: _unknownKey)
class ExploreContentSectionDTO with _$ExploreContentSectionDTO {
  @FreezedUnionValue('ArticlesExploreArea')
  factory ExploreContentSectionDTO.articles(
    String id,
    String name,
    List<ArticleDTO> articles,
  ) = _ExploreContentSectionDTOArticles;

  @FreezedUnionValue('ArticlesWithFeatureExploreArea')
  factory ExploreContentSectionDTO.articlesWithFeature(
    String id,
    String name,
    String backgroundColor,
    List<ArticleDTO> articles,
  ) = _ExploreContentSectionDTOArticlesWithFeature;

  @FreezedUnionValue('TopicsExploreArea')
  factory ExploreContentSectionDTO.topics(
    String id,
    String name,
    List<TopicDTO> topics,
  ) = _ExploreContentSectionDTOTopics;

  @FreezedUnionValue(_unknownKey)
  factory ExploreContentSectionDTO.unknown() = _ExploreContentSectionDTOUnknown;

  factory ExploreContentSectionDTO.fromJson(Map<String, dynamic> json) => _$ExploreContentSectionDTOFromJson(json);
}
