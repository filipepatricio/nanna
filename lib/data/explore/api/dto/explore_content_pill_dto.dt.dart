import 'package:better_informed_mobile/data/util/dto_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_content_pill_dto.dt.freezed.dart';
part 'explore_content_pill_dto.dt.g.dart';

@Freezed(unionKey: '__typename', fallbackUnion: unknownKey)
class ExploreContentPillDTO with _$ExploreContentPillDTO {
  @FreezedUnionValue('ArticlesExploreArea')
  factory ExploreContentPillDTO.articles(
    String id,
    String name,
  ) = _ExploreContentPillDTOArticles;

  @FreezedUnionValue('TopicsExploreArea')
  factory ExploreContentPillDTO.topics(
    String id,
    String name,
  ) = _ExploreContentPillDTOTopics;

  @FreezedUnionValue('SmallTopicsExploreArea')
  factory ExploreContentPillDTO.smallTopics(
    String id,
    String name,
  ) = _ExploreContentPillDTOSmallTopics;

  @FreezedUnionValue('HighlightedTopicsExploreArea')
  factory ExploreContentPillDTO.highlightedTopics(
    String id,
    String name,
  ) = _ExploreContentPillDTOHighlightedTopics;

  @FreezedUnionValue(unknownKey)
  factory ExploreContentPillDTO.unknown(String id) = _ExploreContentPillDTOUnknown;

  factory ExploreContentPillDTO.fromJson(Map<String, dynamic> json) => _$ExploreContentPillDTOFromJson(json);
}
