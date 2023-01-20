import 'package:better_informed_mobile/data/article/database/mapper/article_header_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/bookmark/database/entity/bookmark_data_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/mapper/topic_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_data.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookmarkDataEntityMapper implements BidirectionalMapper<BookmarkDataEntity, BookmarkData> {
  BookmarkDataEntityMapper(
    this._articleHeaderEntityMapper,
    this._topicEntityMapper,
  );

  final ArticleHeaderEntityMapper _articleHeaderEntityMapper;
  final TopicEntityMapper _topicEntityMapper;

  @override
  BookmarkDataEntity from(BookmarkData data) {
    return data.map(
      article: (value) => BookmarkDataEntity.article(_articleHeaderEntityMapper.from(value.article)),
      topic: (value) => BookmarkDataEntity.topic(_topicEntityMapper.from(value.topic)),
      unknown: (value) => throw Exception('Invalid BookmarkData'),
    );
  }

  @override
  BookmarkData to(BookmarkDataEntity data) {
    return data.map(
      article: (value) => BookmarkData.article(_articleHeaderEntityMapper.to(value)),
      topic: (value) => BookmarkData.topic(_topicEntityMapper.to(value)),
    );
  }
}
