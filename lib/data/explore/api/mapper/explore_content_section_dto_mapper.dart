import 'package:better_informed_mobile/data/article/api/mapper/article_dto_to_media_item_mapper.dart';
import 'package:better_informed_mobile/data/explore/api/dto/explore_content_section_dto.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_dto_mapper.dart';
import 'package:better_informed_mobile/data/util/color_dto_mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_section.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExploreContentSectionDTOMapper implements Mapper<ExploreContentSectionDTO, ExploreContentSection> {
  final ArticleDTOToMediaItemMapper _articleDTOToMediaItemMapper;
  final TopicDTOMapper _topicDTOMapper;
  final ColorDTOMapper _colorDTOMapper;

  ExploreContentSectionDTOMapper(
    this._articleDTOToMediaItemMapper,
    this._topicDTOMapper,
    this._colorDTOMapper,
  );

  @override
  ExploreContentSection call(ExploreContentSectionDTO data) {
    return data.map(
      articles: (section) => ExploreContentSection.articles(
        title: section.name,
        articles: section.articles.map<MediaItemArticle>(_articleDTOToMediaItemMapper).toList(),
      ),
      articlesWithFeature: (section) {
        final items = section.articles.map<MediaItemArticle>(_articleDTOToMediaItemMapper).toList();
        final feature = items.first;
        final list = items.skip(1).toList();

        return ExploreContentSection.articleWithFeature(
          title: section.name,
          backgroundColor: _colorDTOMapper(section.backgroundColor),
          featuredArticle: feature,
          articles: list,
        );
      },
      topics: (section) => ExploreContentSection.topics(
        title: section.name,
        topics: section.topics.map<Topic>(_topicDTOMapper).toList(),
      ),
      unknown: (section) => throw Exception('Unknown section'),
    );
  }
}
