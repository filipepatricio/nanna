import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_event.dt.freezed.dart';

@Freezed(toJson: false)
class AnalyticsEvent with _$AnalyticsEvent {
  factory AnalyticsEvent._(String name, [Map<String, dynamic>? properties]) = _AnalyticsEvent;

  factory AnalyticsEvent.dailyBriefEntryPreviewed(String briefId, String topicId, int position, String type) =>
      AnalyticsEvent._(
        'DailyBriefItemPreviewed',
        {
          'brief_id': briefId,
          'item_id': topicId,
          'position': position,
          'type': type,
        },
      );

  factory AnalyticsEvent.dailyBriefRelaxMessageViewed(String briefId) => AnalyticsEvent._(
        'DailyBriefRelaxMessageViewed',
        {
          'brief_id': briefId,
        },
      );

  factory AnalyticsEvent.briefCalendarOpened(String briefId) => AnalyticsEvent._(
        'BriefCalendarOpened',
        {
          'brief_id': briefId,
        },
      );

  factory AnalyticsEvent.briefCalendarClosed(String briefId) => AnalyticsEvent._(
        'BriefCalendarClosed',
        {
          'brief_id': briefId,
        },
      );

  factory AnalyticsEvent.calendarBriefSelected(String briefId, {required bool isTodaysBrief}) => AnalyticsEvent._(
        'CalendarBriefSelected',
        {
          'brief_id': briefId,
          'is_todays_brief': isTodaysBrief ? 'true' : 'false',
        },
      );

  factory AnalyticsEvent.topicSummaryRead(String topicId) => AnalyticsEvent._(
        'TopicSummaryRead',
        {
          'topic_id': topicId,
        },
      );

  factory AnalyticsEvent.readingListBrowsed(String topicId, int position) => AnalyticsEvent._(
        'ReadingListBrowsed',
        {
          'topic_id': topicId,
          'reading_list_position': position,
        },
      );

  factory AnalyticsEvent.onboardingStarted() => AnalyticsEvent._('OnboardingStarted');

  factory AnalyticsEvent.onboardingCompleted() => AnalyticsEvent._('OnboardingCompleted');

  factory AnalyticsEvent.onboardingSkipped() => AnalyticsEvent._('OnboardingSkipped');

  factory AnalyticsEvent.pushNotificationConsentGiven() => AnalyticsEvent._('PushNotificationConsentGiven');

  factory AnalyticsEvent.exploreAreaPreviewed(String id, int position) => AnalyticsEvent._(
        'ExploreAreaPreviewed',
        {
          'explore_area_id': id,
          'position': position,
        },
      );

  factory AnalyticsEvent.exploreAreaCarouselBrowsed(String id, int position) => AnalyticsEvent._(
        'ExploreAreaCarouselBrowsed',
        {
          'explore_area_id': id,
          'position': position,
        },
      );

  factory AnalyticsEvent.exploreAreaScrolled(String id, int offset) => AnalyticsEvent._(
        'ExploreAreaScrolled',
        {
          'explore_area_id': id,
          'offset': offset,
        },
      );

  factory AnalyticsEvent.categoryPageScrolled(String slug, int offset) => AnalyticsEvent._(
        'CategoryPageScrolled',
        {
          'category_slug': slug,
          'offset': offset,
        },
      );

  factory AnalyticsEvent.pushNotificationTapped(Map<String, dynamic> meta) => AnalyticsEvent._(
        'PushNotificationTapped',
        meta,
      );

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

  factory AnalyticsEvent.storyArticleQuoteShared(String articleId, String quote) => AnalyticsEvent._(
        'ArticleQuoteShared',
        {
          'article_id': articleId,
          'quote': quote,
          'type': 'story',
        },
      );

  factory AnalyticsEvent.articleShared(String articleId) => AnalyticsEvent._(
        'ArticleShared',
        {
          'article_id': articleId,
        },
      );

  factory AnalyticsEvent.topicShared(String topicId) => AnalyticsEvent._(
        'TopicShared',
        {
          'topic_id': topicId,
        },
      );

  factory AnalyticsEvent.topicBookmarkAdded(String topicId, [String? briefId]) => AnalyticsEvent._(
        'TopicFollowed',
        {
          'topic_id': topicId,
          'brief_id': briefId,
        },
      );

  factory AnalyticsEvent.topicBookmarkRemoved(String topicId, [String? briefId]) => AnalyticsEvent._(
        'TopicUnfollowed',
        {
          'topic_id': topicId,
          'brief_id': briefId,
        },
      );

  factory AnalyticsEvent.topicBookmarkRemoveUndo(String topicId, [String? briefId]) => AnalyticsEvent._(
        'TopicUnfollowUndo',
        {
          'topic_id': topicId,
          'brief_id': briefId,
        },
      );

  factory AnalyticsEvent.articleBookmarkAdded(String articleId, [String? topicId, String? briefId]) => AnalyticsEvent._(
        'ArticleSaved',
        {
          'article_id': articleId,
          'topic_id': topicId,
          'brief_id': briefId,
        },
      );

  factory AnalyticsEvent.articleBookmarkRemoved(String articleId, [String? topicId, String? briefId]) =>
      AnalyticsEvent._(
        'ArticleUnsaved',
        {
          'article_id': articleId,
          'topic_id': topicId,
          'brief_id': briefId,
        },
      );

  factory AnalyticsEvent.articleBookmarkRemoveUndo(String articleId, [String? topicId, String? briefId]) =>
      AnalyticsEvent._(
        'ArticleUnsavedUndo',
        {
          'article_id': articleId,
          'topic_id': topicId,
          'brief_id': briefId,
        },
      );

  factory AnalyticsEvent.bookmarkSortingOptionSelected(BookmarkSortConfigName configName) => AnalyticsEvent._(
        'SortingOptionSelected',
        {
          'sort_option': configName.eventPropertyName,
        },
      );

  factory AnalyticsEvent.playedArticleAudio(String articleId) => AnalyticsEvent._(
        'PlayedArticleAudio',
        {
          'article_id': articleId,
        },
      );

  factory AnalyticsEvent.pausedArticleAudio(String articleId) => AnalyticsEvent._(
        'PausedArticleAudio',
        {
          'article_id': articleId,
        },
      );

  factory AnalyticsEvent.listenedToArticleAudio(String articleId) => AnalyticsEvent._(
        'ListenedToArticleAudio',
        {
          'article_id': articleId,
        },
      );

  factory AnalyticsEvent.imageCaptionRead({String? topicId, String? articleId}) => AnalyticsEvent._(
        'ImageCaptionRead',
        {
          'topic_id': topicId,
          'article_id': articleId,
        },
      );

  factory AnalyticsEvent.articleMoreFromTopicItemTapped(String articleId, MediaItem item) => AnalyticsEvent._(
        'ArticleMoreFromTopicItemTapped',
        {
          'article_id': articleId,
          'item_type': item.typeName,
          'item_id': item.typeId,
        },
      );

  factory AnalyticsEvent.articleMoreFromBriefItemTapped(String articleId, BriefEntryItem item) => AnalyticsEvent._(
        'ArticleMoreFromBriefItemTapped',
        {
          'article_id': articleId,
          'item_type': item.typeName,
          'item_id': item.typeId,
        },
      );

  factory AnalyticsEvent.articleRelatedCategoryTapped(String articleId, String categoryName) => AnalyticsEvent._(
        'ArticleRelatedCategoryTapped',
        {
          'article_id': articleId,
          'category_name': categoryName,
        },
      );

  factory AnalyticsEvent.logout() => AnalyticsEvent._('Logout');

  factory AnalyticsEvent.searched({required String query}) => AnalyticsEvent._(
        'Searched',
        {
          'query': query,
        },
      );

  factory AnalyticsEvent.articleRelatedContentItemTapped(String articleId, CategoryItem item) => AnalyticsEvent._(
        'ArticleRelatedContentItemTapped',
        {
          'article_id': articleId,
          'item_type': item.typeName,
          'item_id': item.typeId,
        },
      );

  factory AnalyticsEvent.subscriptionPageDismissed() => AnalyticsEvent._('SubscriptionPageDismissed');

  factory AnalyticsEvent.subscriptionPlanSelected({required String packageId}) => AnalyticsEvent._(
        'SubscriptionPlanSelected',
        {
          'package_id': packageId,
        },
      );

  factory AnalyticsEvent.subscriptionPlanPurchased({required String packageId}) => AnalyticsEvent._(
        'SubscriptionPlanPurchased',
        {
          'package_id': packageId,
        },
      );

  factory AnalyticsEvent.purchaseRestored() => AnalyticsEvent._('PurchaseRestored');

  factory AnalyticsEvent.appUpdateDialogShown({
    required String currentVersion,
    required String? availableVersion,
  }) =>
      AnalyticsEvent._(
        'AppUpdateDialogShown',
        {
          'current_version': currentVersion,
          'available_version': availableVersion,
        },
      );
}

extension on BookmarkSortConfigName {
  String get eventPropertyName {
    switch (this) {
      case BookmarkSortConfigName.lastUpdated:
        return 'last_updated';
      case BookmarkSortConfigName.lastAdded:
        return 'last_added';
      case BookmarkSortConfigName.alphabeticalAsc:
        return 'a_z';
      case BookmarkSortConfigName.alphabeticalDesc:
        return 'a_z_reversed';
    }
  }
}

extension on BriefEntryItem {
  String get typeName => map(
        article: (_) => 'article',
        topicPreview: (_) => 'topic',
        unknown: (_) => 'unknown',
      );

  String get typeId => map(
        article: (item) => item.article.map(
          article: (article) => article.id,
          unknown: (_) => 'unknown',
        ),
        topicPreview: (item) => item.topicPreview.id,
        unknown: (_) => 'unknown',
      );
}

extension on MediaItem {
  String get typeName => map(
        article: (_) => 'article',
        unknown: (_) => 'unknown',
      );

  String get typeId => map(
        article: (item) => item.id,
        unknown: (_) => 'unknown',
      );
}
