import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_current_brief_use_case.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:injectable/injectable.dart';

@injectable
class TabsNavigationObserver extends AutoRouterObserver {
  final TrackActivityUseCase _trackActivityUseCase;
  final GetCurrentBriefUseCase _getCurrentBriefUseCase;
  CurrentBrief? _currentBrief;

  TabsNavigationObserver(this._trackActivityUseCase, this._getCurrentBriefUseCase);

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) => _trackTabView(route.name);

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) => _trackTabView(route.name);

  Future<void> _trackTabView(String name) async {
    switch (name) {
      case TodayTabGroupRouter.name:
        _currentBrief ??= await _getCurrentBriefUseCase.stream.first;
        return _trackActivityUseCase.trackDailyBriefPage(_currentBrief!.id);
      case ExploreTabGroupRouter.name:
        return _trackActivityUseCase.trackPage('Explore Section');
      case ProfileTabGroupRouter.name:
        return _trackActivityUseCase.trackPage('Profile');
      default:
        return;
    }
  }
}
