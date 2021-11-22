import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_event.freezed.dart';

@freezed
class AnalyticsEvent with _$AnalyticsEvent {
  factory AnalyticsEvent._(String name, Map<String, dynamic>? properties) = _AnalyticsEvent;

  factory AnalyticsEvent.dailyBriefTopicPreviewed(String briefId, String topicId, int position) =>
      AnalyticsEvent._('DailyBriefTopicPreviewed', {'brief_id': briefId, 'topic_id': topicId, 'position': position});

  factory AnalyticsEvent.dailyBriefRelaxMessageViewed(String briefId) =>
      AnalyticsEvent._('DailyBriefRelaxMessageViewed', {'brief_id': briefId});

  @override
  String toString() => 'Event $name, ${properties != null ? jsonEncode(properties) : 'No properties'}';
}
