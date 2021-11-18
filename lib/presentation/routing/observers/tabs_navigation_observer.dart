import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/main/main_cubit.dart';

class TabsNavigationObserver extends AutoRouterObserver {
  final MainCubit mainCubit;

  TabsNavigationObserver(this.mainCubit);

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    // The initialization of the Today tab is asynchronous,
    // so the currentBriefId is not yet available at this point and I cannot use this method to log it
    if (route.name != TodayTabGroupRouter.name) mainCubit.trackTabView(route.name);
    return;
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    mainCubit.trackTabView(route.name);
    return;
  }
}
