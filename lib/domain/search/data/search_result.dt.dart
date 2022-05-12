import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result.dt.freezed.dart';

@freezed
class SearchResult with _$SearchResult {
  factory SearchResult.article(MediaItemArticle article) = _SearchResultArticle;

  factory SearchResult.topic(TopicPreview topicPreview) = _SearchResultTopic;

  factory SearchResult.unknown() = _SearchResultUnknown;
}
