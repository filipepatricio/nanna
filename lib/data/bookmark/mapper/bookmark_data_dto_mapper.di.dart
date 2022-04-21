import 'package:better_informed_mobile/data/article/api/mapper/article_dto_to_media_item_mapper.di.dart';
import 'package:better_informed_mobile/data/bookmark/dto/bookmark_data_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_preview_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_data.dt.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookmarkDataDTOMapper implements Mapper<BookmarkDataDTO, BookmarkData> {
  BookmarkDataDTOMapper(this._topicPreviewDTOMapper, this._articleDTOMapper);

  final TopicPreviewDTOMapper _topicPreviewDTOMapper;
  final ArticleDTOToMediaItemMapper _articleDTOMapper;

  @override
  BookmarkData call(BookmarkDataDTO data) {
    return data.map(
      topic: (topic) => BookmarkData.topic(_topicPreviewDTOMapper(topic.topic)),
      article: (article) => BookmarkData.article(_articleDTOMapper(article.article)),
      unknown: (unknown) {
        Fimber.e('Encountered unknown bookmark data with type: ${unknown.type}');
        return BookmarkData.unknown();
      },
    );
  }
}
