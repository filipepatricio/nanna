import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_current_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/should_use_observable_queries_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:injectable/injectable.dart';

@injectable
class TabsNavigationObserver extends AutoRouterObserver {
  TabsNavigationObserver(
    this._trackActivityUseCase,
    this._getCurrentBriefUseCase,
    this._shouldUseObservableQueriesUseCase,
  );

  final TrackActivityUseCase _trackActivityUseCase;
  final GetCurrentBriefUseCase _getCurrentBriefUseCase;
  final ShouldUseObservableQueriesUseCase _shouldUseObservableQueriesUseCase;

  Brief? _currentBrief;

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) => _trackTabView(route.name);

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) => _trackTabView(route.name);

  Future<void> _trackTabView(String name) async {
    switch (name) {
      case DailyBriefTabGroupRouter.name:
        if (_currentBrief == null) {
          final shouldUseObservableQueries = await _shouldUseObservableQueriesUseCase();
          final currentBriefWrapper =
              shouldUseObservableQueries ? await _getCurrentBriefUseCase.stream.first : await _getCurrentBriefUseCase();

          _currentBrief = currentBriefWrapper.currentBrief;
        }

        return _trackActivityUseCase.trackPage(AnalyticsPage.dailyBrief(_currentBrief!.id));
      case ExploreTabGroupRouter.name:
        return _trackActivityUseCase.trackPage(AnalyticsPage.exploreSection());
      case ProfileTabGroupRouter.name:
        return _trackActivityUseCase.trackPage(AnalyticsPage.profile());
      default:
        return;
    }
  }
}
