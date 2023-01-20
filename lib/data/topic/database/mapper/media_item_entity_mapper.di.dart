import 'package:better_informed_mobile/data/article/database/mapper/article_header_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/topic/database/entity/media_item_entity.hv.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class MediaItemEntityMapper extends BidirectionalMapper<MediaItemEntity, MediaItem> {
  MediaItemEntityMapper(this._articleHeaderEntityMapper);

  final ArticleHeaderEntityMapper _articleHeaderEntityMapper;

  @override
  MediaItemEntity from(MediaItem data) {
    return data.map(
      article: (article) {
        return MediaItemEntity.article(
          _articleHeaderEntityMapper.from(article),
        );
      },
      unknown: (_) => throw Exception('Invalid MediaItem'),
    );
  }

  @override
  MediaItem to(MediaItemEntity data) {
    return data.map(
      article: (article) {
        return _articleHeaderEntityMapper.to(article);
      },
    );
  }
}
