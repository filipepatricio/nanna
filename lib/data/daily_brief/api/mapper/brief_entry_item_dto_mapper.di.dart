import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_entry_item_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_entry_item_media_item_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_entry_topic_preview_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefEntryItemDTOMapper implements Mapper<BriefEntryItemDTO, BriefEntryItem> {
  final BriefEntryMediaItemDTOMapper _briefEntryMediaItemDTOMapper;
  final BriefEntryTopicPreviewDTOMapper _briefEntryTopicPreviewDTOMapper;

  BriefEntryItemDTOMapper(
    this._briefEntryMediaItemDTOMapper,
    this._briefEntryTopicPreviewDTOMapper,
  );

  @override
  BriefEntryItem call(BriefEntryItemDTO data) {
    final article = _briefEntryMediaItemDTOMapper(data);
    final topicPreview = _briefEntryTopicPreviewDTOMapper(data);
    return data.map(
      article: (data) {
        return article != null ? BriefEntryItem.article(article: article) : const BriefEntryItem.unknown();
      },
      topicPreview: (data) {
        return topicPreview != null
            ? BriefEntryItem.topicPreview(topicPreview: topicPreview)
            : const BriefEntryItem.unknown();
      },
      unknown: (_) => const BriefEntryItem.unknown(),
    );
  }
}
