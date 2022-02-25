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

  factory AnalyticsEvent.exploreAreaPreviewed(String id, int position) =>
      AnalyticsEvent._('ExploreAreaPreviewed', {'explore_area_id': id, 'position': position});

  factory AnalyticsEvent.exploreAreaCarouselBrowsed(String id, int position) =>
      AnalyticsEvent._('ExploreAreaCarouselBrowsed', {'explore_area_id': id, 'position': position});

  factory AnalyticsEvent.exploreAreaScrolled(String id, int offset) =>
      AnalyticsEvent._('ExploreAreaScrolled', {'explore_area_id': id, 'offset': offset});

  factory AnalyticsEvent.pushNotificationTapped(Map<String, dynamic> meta) =>
      AnalyticsEvent._('PushNotificationTapped', meta);

  factory AnalyticsEvent.imageArticleQuoteShared(String articleId, String quote) => AnalyticsEvent._(
        'ArticleQuoteShared',
        {
          'article_id': articleId,
          'quote': quote,
          'type': 'image',
        },
      );

  factory AnalyticsEvent.textArticleQuoteShared(String articleId, String quote) => AnalyticsEvent._(
        'ArticleQuoteShared',
        {
          'article_id': articleId,
          'quote': quote,
          'type': 'text',
        },
      );
}
