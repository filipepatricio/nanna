import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'other_brief_entry_item.dt.freezed.dart';

@freezed
class OtherBriefEntryItem with _$OtherBriefEntryItem {
  const factory OtherBriefEntryItem.article({
    required String id,
    required String slug,
    required ArticleProgressState progressState,
    MediaItemArticle? article,
  }) = OtherBriefEntryItemArticle;

  const factory OtherBriefEntryItem.topicPreview({
    required String id,
    required String slug,
    required bool visited,
    Topic? topic,
  }) = OtherBriefEntryItemTopic;

  const factory OtherBriefEntryItem.unknown() = _OtherBriefEntryItemUnknown;
}
