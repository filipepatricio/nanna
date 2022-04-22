import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_data.dt.freezed.dart';

@freezed
class BookmarkData with _$BookmarkData {
  factory BookmarkData.article(MediaItemArticle article) = _BookmarkDataArticle;

  factory BookmarkData.topic(Topic topic) = _BookmarkDataTopic;

  factory BookmarkData.unknown() = _BookmarkDataUnknown;
}
