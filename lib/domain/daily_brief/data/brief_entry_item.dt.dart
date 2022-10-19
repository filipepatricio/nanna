import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'brief_entry_item.dt.freezed.dart';

@Freezed(toJson: false)
class BriefEntryItem with _$BriefEntryItem {
  const factory BriefEntryItem.article({
    required MediaItem article,
  }) = BriefEntryItemArticle;

  const factory BriefEntryItem.topicPreview({
    required TopicPreview topicPreview,
  }) = BriefEntryItemTopic;

  const factory BriefEntryItem.unknown() = _BriefEntryItemUnknown;
}
