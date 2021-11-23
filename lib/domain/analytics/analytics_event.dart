import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_event.freezed.dart';

@freezed
class AnalyticsEvent with _$AnalyticsEvent {
  factory AnalyticsEvent._(String name, [Map<String, dynamic>? properties]) = _AnalyticsEvent;

  factory AnalyticsEvent.dailyBriefTopicPreviewed(String briefId, String topicId, int position) =>
      AnalyticsEvent._('DailyBriefTopicPreviewed', {'brief_id': briefId, 'topic_id': topicId, 'position': position});

  factory AnalyticsEvent.dailyBriefRelaxMessageViewed(String briefId) =>
      AnalyticsEvent._('DailyBriefRelaxMessageViewed', {'brief_id': briefId});

  factory AnalyticsEvent.topicSummaryRead(String topicId) =>
      AnalyticsEvent._('TopicSummaryRead', {'topic_id': topicId});

  factory AnalyticsEvent.readingListBrowsed(String topicId, int position) =>
      AnalyticsEvent._('ReadingListBrowsed', {'topic_id': topicId, 'reading_list_position': position});

  factory AnalyticsEvent.onboardingStarted() => AnalyticsEvent._('OnboardingStarted');

  factory AnalyticsEvent.onboardingCompleted() => AnalyticsEvent._('OnboardingCompleted');

  factory AnalyticsEvent.onboardingSkipped() => AnalyticsEvent._('OnboardingSkipped');

  factory AnalyticsEvent.pushNotificationConsentGiven() => AnalyticsEvent._('PushNotificationConsentGiven');
}
