import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/core/di/di_config.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:flutter/material.dart';

class MainNavigationObserver extends AutoRouterObserver {
  final TrackActivityUseCase _trackActivityUseCase;

  MainNavigationObserver() : _trackActivityUseCase = getIt<TrackActivityUseCase>();

  @override
  void didPush(Route route, Route? previousRoute) {
    switch (route.settings.name) {
      case TopicPageRoute.name:
        final args = route.settings.arguments as TopicPageRouteArgs;
        final topicId = args.currentBrief.topics[args.index].id;
        return _trackActivityUseCase.trackTopicPage(topicId);
      case SingleTopicPageRoute.name:
        final args = route.settings.arguments as SingleTopicPageRouteArgs;
        final topicId = args.topic.id;
        return _trackActivityUseCase.trackTopicPage(topicId);
      case MediaItemPageRoute.name:
        // Handled in MediaItemCubit
        return;
      case ArticleSeeAllPageRoute.name:
        final args = route.settings.arguments as ArticleSeeAllPageRouteArgs;
        return _trackActivityUseCase.trackExploreAreaPage(args.areaId);
      case TopicsSeeAllPageRoute.name:
        final args = route.settings.arguments as TopicsSeeAllPageRouteArgs;
        return _trackActivityUseCase.trackExploreAreaPage(args.areaId);
      default:
        switch (route.settings.name) {
          case SettingsMainPageRoute.name:
            return _trackActivityUseCase.trackPage('Settings');
          case SettingsAccountPageRoute.name:
            return _trackActivityUseCase.trackPage('Account Settings');
          case SettingsNotificationsPageRoute.name:
            return _trackActivityUseCase.trackPage('Notification Settings');
        }
        return;
    }
  }
}
