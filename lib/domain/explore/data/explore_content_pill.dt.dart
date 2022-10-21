import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_content_pill.dt.freezed.dart';

@Freezed(toJson: false)
class ExploreContentPill with _$ExploreContentPill {
  factory ExploreContentPill.articles({
    required String id,
    required String title,
    required String? icon,
  }) = ExploreContentPillArticles;

  factory ExploreContentPill.topics({
    required String id,
    required String title,
    required String? icon,
  }) = ExploreContentPillTopics;

  factory ExploreContentPill.unknown({
    required String id,
  }) = ExploreContentPillUnknown;
}
