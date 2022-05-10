import 'package:better_informed_mobile/data/explore/api/dto/explore_content_pill_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_pill.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExploreContentPillDTOMapper implements Mapper<ExploreContentPillDTO, ExploreContentPill> {
  @override
  ExploreContentPill call(ExploreContentPillDTO data) {
    return data.map(
      articles: (pill) => ExploreContentPill.articles(
        id: pill.id,
        title: pill.name,
        icon: pill.icon,
      ),
      articlesWithFeature: (pill) => ExploreContentPill.articles(
        id: pill.id,
        title: pill.name,
        icon: pill.icon,
      ),
      topics: (pill) => ExploreContentPill.topics(
        id: pill.id,
        title: pill.name,
        icon: pill.icon,
      ),
      smallTopics: (area) => ExploreContentPill.topics(
        id: area.id,
        title: area.name,
      ),
      highlightedTopics: (area) => ExploreContentPill.topics(
        id: area.id,
        title: area.name,
      ),
      unknown: (area) => ExploreContentPill.unknown(id: area.id),
    );
  }
}
