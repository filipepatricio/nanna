import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_entry_item_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/mapper/media_item_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/database/mapper/topic_preview_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefEntryItemEntityMapper implements BidirectionalMapper<BriefEntryItemEntity, BriefEntryItem> {
  BriefEntryItemEntityMapper(
    this._mediaItemEntityMapper,
    this._topicPreviewEntityMapper,
  );

  final MediaItemEntityMapper _mediaItemEntityMapper;
  final TopicPreviewEntityMapper _topicPreviewEntityMapper;

  @override
  BriefEntryItemEntity from(BriefEntryItem data) {
    return data.map(
      article: (data) => BriefEntryItemEntity.article(
        BriefEntryItemArticleEntity(_mediaItemEntityMapper.from(data.article)),
      ),
      topicPreview: (data) => BriefEntryItemEntity.topic(
        BriefEntryItemTopicEntity(
          _topicPreviewEntityMapper.from(data.topicPreview),
        ),
      ),
      unknown: (data) => const BriefEntryItemEntity.unknown(),
    );
  }

  @override
  BriefEntryItem to(BriefEntryItemEntity data) {
    return data.map(
      article: (data) => BriefEntryItem.article(article: _mediaItemEntityMapper.to(data.article)),
      topic: (data) => BriefEntryItem.topicPreview(topicPreview: _topicPreviewEntityMapper.to(data.topic)),
      unknown: (data) => const BriefEntryItem.unknown(),
    );
  }
}
