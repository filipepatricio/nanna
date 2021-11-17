import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/main/main_cubit.dart';
import 'package:flutter/material.dart';

class MainNavigationObserver extends AutoRouterObserver {
  final MainCubit mainCubit;

  MainNavigationObserver(this.mainCubit);

  @override
  void didPush(Route route, Route? previousRoute) {
    _logView(route, previousRoute);
  }

  Future<void> _logView(Route route, Route? previousRoute) async {
    switch (route.settings.name) {
      case TopicPageRoute.name:
        final args = route.settings.arguments as TopicPageRouteArgs;
        final topicId = args.currentBrief.topics[args.index].id;
        return await mainCubit.logTopicView(topicId);
      case SingleTopicPageRoute.name:
        final args = route.settings.arguments as SingleTopicPageRouteArgs;
        final topicId = args.topic.id;
        return await mainCubit.logTopicView(topicId);
      case MediaItemPageRoute.name:
        // Handled in MediaItemCubit
        return;
      case ArticleSeeAllPageRoute.name:
        final args = route.settings.arguments as ArticleSeeAllPageRouteArgs;
        return await mainCubit.logExploreAreaView(args.areaId);
      case TopicsSeeAllPageRoute.name:
        final args = route.settings.arguments as TopicsSeeAllPageRouteArgs;
        return await mainCubit.logExploreAreaView(args.areaId);
      default:
        return await mainCubit.logPageView(route.settings.name);
    }
  }
}
