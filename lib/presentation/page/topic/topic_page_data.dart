import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_page_data.freezed.dart';

@freezed
class TopicPageData with _$TopicPageData {
  factory TopicPageData.item({
    required Topic topic,
    String? briefId,
  }) = TopicPageDataItem;
}
