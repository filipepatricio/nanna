import 'package:better_informed_mobile/data/article/api/mapper/article_dto_to_media_item_mapper.di.dart';
import 'package:better_informed_mobile/data/bookmark/api/dto/bookmark_data_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_data.dt.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookmarkDataDTOMapper implements Mapper<BookmarkDataDTO, BookmarkData> {
  BookmarkDataDTOMapper(this._topicDTOMapper, this._articleDTOMapper);

  final TopicDTOMapper _topicDTOMapper;
  final ArticleDTOToMediaItemMapper _articleDTOMapper;

  @override
  BookmarkData call(BookmarkDataDTO data) {
    return data.map(
      topic: (topic) => BookmarkData.topic(_topicDTOMapper(topic.topic)),
      article: (article) => BookmarkData.article(_articleDTOMapper(article.article)),
      unknown: (unknown) {
        Fimber.e('Encountered unknown bookmark data with type: ${unknown.type}');
        return BookmarkData.unknown();
      },
    );
  }
}
