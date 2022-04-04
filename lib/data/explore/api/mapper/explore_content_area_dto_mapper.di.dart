import 'package:better_informed_mobile/data/article/api/mapper/article_dto_to_media_item_mapper.di.dart';
import 'package:better_informed_mobile/data/explore/api/dto/explore_content_area_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/util/color_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/util/dto_config.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExploreContentAreaDTOMapper implements Mapper<ExploreContentAreaDTO, ExploreContentArea> {
  final ArticleDTOToMediaItemMapper _articleDTOToMediaItemMapper;
  final TopicDTOMapper _topicDTOMapper;
  final ColorDTOMapper _colorDTOMapper;

  ExploreContentAreaDTOMapper(
    this._articleDTOToMediaItemMapper,
    this._topicDTOMapper,
    this._colorDTOMapper,
  );

  @override
  ExploreContentArea call(ExploreContentAreaDTO data) {
    return data.map(
      articles: (area) => ExploreContentArea.articles(
        id: area.id,
        title: area.name,
        articles: area.articles.map<MediaItemArticle>(_articleDTOToMediaItemMapper).toList(),
      ),
      articlesWithFeature: (area) {
        final articles = area.articles.map<MediaItemArticle>(_articleDTOToMediaItemMapper).toList();

        if (articles.isEmpty) {
          return ExploreContentArea.articles(
            id: area.id,
            title: area.name,
            articles: [],
          );
        }

        final feature = articles.first;
        final list = articles.skip(1).toList();

        return ExploreContentArea.articleWithFeature(
          id: area.id,
          title: area.name,
          backgroundColor: _colorDTOMapper(area.backgroundColor),
          featuredArticle: feature,
          articles: list,
        );
      },
      topics: (area) => ExploreContentArea.topics(
        id: area.id,
        title: area.name,
        topics: area.topics.map<Topic>(_topicDTOMapper).toList(),
      ),
      unknown: (_) => ExploreContentArea.unknown(id: unknownKey),
    );
  }
}
