import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/core/di/di_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/main/widgets/bottom_navigation.dart';
import 'package:better_informed_mobile/presentation/routing/observers/tabs_navigation_observer.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

final dashboardPageKey = GlobalKey();

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarDividerColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: AutoTabsScaffold(
          key: dashboardPageKey,
          animationDuration: const Duration(),
          routes: const [
            TodayTabGroupRouter(),
            ExploreTabGroupRouter(),
            ProfileTabGroupRouter(),
          ],
          bottomNavigationBuilder: (context, tabsRouter) => BottomNavigation(tabsRouter),
          navigatorObservers: () => [getIt<TabsNavigationObserver>()],
        ),
      ),
    );
  }
}
