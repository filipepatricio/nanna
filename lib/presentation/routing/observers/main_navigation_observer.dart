import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/main/main_cubit.dart';
import 'package:flutter/material.dart';

class MainNavigationObserver extends AutoRouterObserver {
  final MainCubit mainCubit;

  MainNavigationObserver(this.mainCubit);

  @override
  void didPush(Route route, Route? previousRoute) => _logView(route, previousRoute);

  void _logView(Route route, Route? previousRoute) {
    switch (route.settings.name) {
      case TopicPageRoute.name:
        final args = route.settings.arguments as TopicPageRouteArgs;
        final topicId = args.currentBrief.topics[args.index].id;
        return mainCubit.trackTopicView(topicId);
      case SingleTopicPageRoute.name:
        final args = route.settings.arguments as SingleTopicPageRouteArgs;
        final topicId = args.topic.id;
        return mainCubit.trackTopicView(topicId);
      case MediaItemPageRoute.name:
        // Handled in MediaItemCubit
        return;
      case ArticleSeeAllPageRoute.name:
        final args = route.settings.arguments as ArticleSeeAllPageRouteArgs;
        return mainCubit.trackExploreAreaView(args.areaId);
      case TopicsSeeAllPageRoute.name:
        final args = route.settings.arguments as TopicsSeeAllPageRouteArgs;
        return mainCubit.trackExploreAreaView(args.areaId);
      default:
        return mainCubit.trackPageView(route.settings.name);
    }
  }
}
