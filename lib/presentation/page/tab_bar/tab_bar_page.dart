import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/tab_bar_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/widgets/informed_tab_bar.dart';
import 'package:better_informed_mobile/presentation/routing/observers/tabs_navigation_observer.di.dart';
import 'package:better_informed_mobile/presentation/style/app_theme.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/di_util.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/widget/update_app_enforcer/app_update_checker.dart';
import 'package:flutter/material.dart';
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
    final getIt = useGetIt();

    useEffect(
      () {
        cubit.getInitialTab().then(
          (initialTab) {
            if (initialTab.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => context.navigateNamedTo(initialTab),
              );
            }
          },
        );
      },
      [cubit],
    );

    return CupertinoScaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppTheme.systemUIOverlay,
        child: ScrollsToTop(
          onScrollsToTop: (event) async => cubit.scrollToTop(),
          child: AppUpdateChecker(
            child: AutoTabsScaffold(
              builder: (context, child, animation) {
                return AudioPlayerBannerWrapper(
                  layout: AudioPlayerBannerLayout.stack,
                  child: child,
                );
              },
              key: tabBarPageKey,
              animationDuration: Duration.zero,
              routes: const [
                DailyBriefTabGroupRouter(),
                ExploreTabGroupRouter(),
                ProfileTabGroupRouter(),
              ],
              bottomNavigationBuilder: (context, tabsRouter) => InformedTabBar.fixed(router: tabsRouter),
              navigatorObservers: () => [getIt<TabsNavigationObserver>()],
            ),
          ),
        ),
      ),
    );
  }
}
