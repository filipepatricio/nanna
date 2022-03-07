import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/core/di/di_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/tab_bar_cubit.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/widgets/tab_bar.dart';
import 'package:better_informed_mobile/presentation/routing/observers/tabs_navigation_observer.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:flutter/material.dart' hide TabBar;
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';

final tabBarPageKey = GlobalKey();

class TabBarPage extends HookWidget {
  const TabBarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<TabBarCubit>();

    return CupertinoScaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarDividerColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: ScrollsToTop(
          onScrollsToTop: (event) => Future.microtask(() => cubit.scrollToTop()),
          child: AutoTabsScaffold(
            key: tabBarPageKey,
            animationDuration: const Duration(),
            routes: const [
              TodayTabGroupRouter(),
              ExploreTabGroupRouter(),
              ProfileTabGroupRouter(),
            ],
            bottomNavigationBuilder: (context, tabsRouter) => TabBar(tabsRouter),
            navigatorObservers: () => [getIt<TabsNavigationObserver>()],
          ),
        ),
      ),
    );
  }
}
