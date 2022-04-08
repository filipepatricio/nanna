import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_page.dt.freezed.dart';

@freezed
class AnalyticsPage with _$AnalyticsPage {
  factory AnalyticsPage._(String name, [Map<String, dynamic>? properties]) = _AnalyticsPage;

  factory AnalyticsPage.onboarding(int index) => AnalyticsPage._('Onboarding', {'index': index});

  factory AnalyticsPage.exploreArea(String exploreAreaId) =>
      AnalyticsPage._('Explore Area', {'explore_area_id': exploreAreaId});

  factory AnalyticsPage.article(String articleId, [String? topicId]) =>
      AnalyticsPage._('Article', {'article_id': articleId, 'topic_id': topicId});

  factory AnalyticsPage.topic(String topicId, [String? briefId]) =>
      AnalyticsPage._('Topic', {'topic_id': topicId, 'brief_id': briefId});

  factory AnalyticsPage.dailyBrief(String briefId) => AnalyticsPage._('Daily Brief', {'brief_id': briefId});

  factory AnalyticsPage.settings() => AnalyticsPage._('Settings');

  factory AnalyticsPage.accountSettings() => AnalyticsPage._('Account Settings');

  factory AnalyticsPage.notificationSettings() => AnalyticsPage._('Notification Settings');

  factory AnalyticsPage.exploreSection() => AnalyticsPage._('Explore Section');

  factory AnalyticsPage.profile() => AnalyticsPage._('Profile');
}
