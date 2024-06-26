import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/notify_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/util/use_case/request_permissions_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class MainNavigationObserver extends AutoRouterObserver {
  MainNavigationObserver(
    this._trackActivityUseCase,
    this._updateBriefNotifierUseCase,
    this._requestPermissionsUseCase,
  );

  final TrackActivityUseCase _trackActivityUseCase;
  final UpdateBriefNotifierUseCase _updateBriefNotifierUseCase;
  final RequestPermissionsUseCase _requestPermissionsUseCase;

  @override
  Future<void> didPop(Route route, Route? previousRoute) async {
    switch (route.settings.name) {
      case MediaItemPageRoute.name:
        final args = route.settings.arguments as MediaItemPageRouteArgs?;
        if (args?.briefId != null) {
          _updateBriefNotifierUseCase();
        }
        break;
      case SubscriptionPageRoute.name:
        _updateBriefNotifierUseCase();
        break;
      case SubscriptionSuccessPageRoute.name:
        _updateBriefNotifierUseCase();
        await _requestPermissionsUseCase();
        break;
      case AddInterestsPageRoute.name:
        _updateBriefNotifierUseCase();
        await _requestPermissionsUseCase();
        break;
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    switch (route.settings.name) {
      case ArticleSeeAllPageRoute.name:
        final args = route.settings.arguments as ArticleSeeAllPageRouteArgs;
        return _trackActivityUseCase.trackPage(AnalyticsPage.exploreArea(args.areaId, args.referred.name));
      case TopicsSeeAllPageRoute.name:
        final args = route.settings.arguments as TopicsSeeAllPageRouteArgs;
        return _trackActivityUseCase.trackPage(AnalyticsPage.exploreArea(args.areaId, args.referred.name));
      case SettingsMainPageRoute.name:
        return _trackActivityUseCase.trackPage(AnalyticsPage.settings());
      case SettingsAccountPageRoute.name:
        return _trackActivityUseCase.trackPage(AnalyticsPage.accountSettings());
      case SettingsNotificationsPageRoute.name:
        return _trackActivityUseCase.trackPage(AnalyticsPage.notificationSettings());
      case SubscriptionPageRoute.name:
        return _trackActivityUseCase.trackEvent(AnalyticsEvent.paywallTriggered());
    }
  }
}
