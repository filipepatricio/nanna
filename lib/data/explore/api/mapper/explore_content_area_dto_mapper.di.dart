import 'package:better_informed_mobile/data/article/api/mapper/article_dto_to_media_item_mapper.di.dart';
import 'package:better_informed_mobile/data/explore/api/dto/explore_content_area_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_preview_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/util/color_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/util/dto_config.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExploreContentAreaDTOMapper implements Mapper<ExploreContentAreaDTO, ExploreContentArea> {
  ExploreContentAreaDTOMapper(
    this._articleDTOToMediaItemMapper,
    this._topicPreviewDTOMapper,
    this._colorDTOMapper,
  );
  final ArticleDTOToMediaItemMapper _articleDTOToMediaItemMapper;
  final TopicPreviewDTOMapper _topicPreviewDTOMapper;
  final ColorDTOMapper _colorDTOMapper;

  @override
  ExploreContentArea call(ExploreContentAreaDTO data) {
    return data.map(
      articles: (area) => ExploreContentArea.articles(
        id: area.id,
        title: area.name,
        description: area.description,
        icon: area.icon,
        backgroundColor: area.backgroundColor != null ? _colorDTOMapper(area.backgroundColor!) : null,
        isHighlighted: area.isHighlighted,
        isPreferred: area.isPreferred,
        articles: area.articles.map<MediaItemArticle>(_articleDTOToMediaItemMapper).toList(),
      ),
      articlesList: (area) => ExploreContentArea.articlesList(
        id: area.id,
        title: area.name,
        description: area.description,
        icon: area.icon,
        backgroundColor: area.backgroundColor != null ? _colorDTOMapper(area.backgroundColor!) : null,
        isHighlighted: area.isHighlighted,
        isPreferred: area.isPreferred,
        articles: area.articles.map<MediaItemArticle>(_articleDTOToMediaItemMapper).toList(),
      ),
      topics: (area) => ExploreContentArea.smallTopics(
        id: area.id,
        title: area.name,
        icon: area.icon,
        backgroundColor: area.backgroundColor != null ? _colorDTOMapper(area.backgroundColor!) : null,
        description: null,
        isHighlighted: area.isHighlighted,
        isPreferred: area.isPreferred,
        topics: area.topics.map<TopicPreview>(_topicPreviewDTOMapper).toList(),
      ),
      smallTopics: (area) => ExploreContentArea.smallTopics(
        id: area.id,
        title: area.name,
        description: area.description,
        icon: area.icon,
        backgroundColor: area.backgroundColor != null ? _colorDTOMapper(area.backgroundColor!) : null,
        isHighlighted: area.isHighlighted,
        isPreferred: area.isPreferred,
        topics: area.topics.map<TopicPreview>(_topicPreviewDTOMapper).toList(),
      ),
      highlightedTopics: (area) => ExploreContentArea.smallTopics(
        id: area.id,
        title: area.name,
        description: area.description,
        icon: area.icon,
        backgroundColor: area.backgroundColor != null ? _colorDTOMapper(area.backgroundColor!) : null,
        isHighlighted: area.isHighlighted,
        isPreferred: area.isPreferred,
        topics: area.topics.map<TopicPreview>(_topicPreviewDTOMapper).toList(),
      ),
      unknown: (_) => ExploreContentArea.unknown(id: unknownKey),
    );
  }
}
