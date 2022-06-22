import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'result_item.dt.freezed.dart';

@freezed
abstract class ResultItem with _$ResultItem {
  factory ResultItem.article(MediaItemArticle article) = _ResultItemArticle;

  factory ResultItem.topic(TopicPreview topicPreview) = _ResultItemTopic;

  factory ResultItem.unknown() = _ResultItemUnknown;
}
