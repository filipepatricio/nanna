import 'package:better_informed_mobile/data/article/api/mapper/article_dto_to_media_item_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/search/api/dto/search_result_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_preview_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/search/data/search_result.dt.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchResultDTOMapper implements Mapper<SearchResultDTO, SearchResult> {
  SearchResultDTOMapper(this._topicDTOMapper, this._articleDTOMapper);

  final TopicPreviewDTOMapper _topicDTOMapper;
  final ArticleDTOToMediaItemMapper _articleDTOMapper;

  @override
  SearchResult call(SearchResultDTO data) {
    return data.map(
      topic: (topic) => SearchResult.topic(_topicDTOMapper(topic.topicPreview)),
      article: (article) => SearchResult.article(_articleDTOMapper(article.article)),
      unknown: (unknown) {
        Fimber.e('Encountered unknown search result with type: ${unknown.type}');
        return SearchResult.unknown();
      },
    );
  }
}
