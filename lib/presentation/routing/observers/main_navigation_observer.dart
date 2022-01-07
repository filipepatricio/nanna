import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/core/di/di_config.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:flutter/material.dart';

class MainNavigationObserver extends AutoRouterObserver {
  final TrackActivityUseCase _trackActivityUseCase;

  MainNavigationObserver() : _trackActivityUseCase = getIt<TrackActivityUseCase>();

  @override
  void didPush(Route route, Route? previousRoute) {
    switch (route.settings.name) {
      case TodaysTopicsTopicPage.name:
        final args = route.settings.arguments as TodaysTopicsTopicPageArgs;
        final topicId = args.pageData.topic.id;
        final briefId = args.pageData.briefId;
        return _trackActivityUseCase.trackPage(AnalyticsPage.topic(topicId, briefId));
      case TopicPageRoute.name:
        final args = route.settings.arguments as TopicPageRouteArgs;
        final topicId = args.pageData.topic.id;
        return _trackActivityUseCase.trackPage(AnalyticsPage.topic(topicId));
      case MediaItemPageRoute.name:
        // Handled in MediaItemCubit
        return;
      case ArticleSeeAllPageRoute.name:
        final args = route.settings.arguments as ArticleSeeAllPageRouteArgs;
        return _trackActivityUseCase.trackPage(AnalyticsPage.exploreArea(args.areaId));
      case TopicsSeeAllPageRoute.name:
        final args = route.settings.arguments as TopicsSeeAllPageRouteArgs;
        return _trackActivityUseCase.trackPage(AnalyticsPage.exploreArea(args.areaId));
      case SettingsMainPageRoute.name:
        return _trackActivityUseCase.trackPage(AnalyticsPage.settings());
      case SettingsAccountPageRoute.name:
        return _trackActivityUseCase.trackPage(AnalyticsPage.accountSettings());
      case SettingsNotificationsPageRoute.name:
        return _trackActivityUseCase.trackPage(AnalyticsPage.notificationSettings());
      default:
        return;
    }
  }
}
