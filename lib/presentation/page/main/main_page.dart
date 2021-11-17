import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/main/main_cubit.dart';
import 'package:better_informed_mobile/presentation/page/main/main_state.dart';
import 'package:better_informed_mobile/presentation/page/main/widgets/bottom_navigation.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

final mainPageKey = GlobalKey();

class MainPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<MainCubit>();
    final state = useCubitBuilder<MainCubit, MainState>(cubit);

    useCubitListener<MainCubit, MainState>(cubit, (cubit, state, context) {
      state.maybeMap(
        tokenExpired: (_) => _onTokenExpiredEvent(context),
        orElse: () {},
      );
    });

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return CupertinoScaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarDividerColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: AutoTabsScaffold(
          key: mainPageKey,
          animationDuration: const Duration(),
          routes: const [
            TodayTabGroupRouter(),
            ExploreTabGroupRouter(),
            ProfileTabGroupRouter(),
          ],
          bottomNavigationBuilder: (context, tabsRouter) => BottomNavigation(
            state,
            cubit,
            tabsRouter,
          ),
          navigatorObservers: () => [TabsNavigationObserver(cubit)],
        ),
      ),
    );
  }

  void _onTokenExpiredEvent(BuildContext context) {
    AutoRouter.of(context).replaceAll(
      [
        const SignInPageRoute(),
      ],
    );
  }
}

class TabsNavigationObserver extends AutoRouterObserver {
  final MainCubit mainCubit;

  TabsNavigationObserver(this.mainCubit);

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
      case MediaItemPageRoute.name:
      // Handled in MediaItemCubit
      default:
        return;
    }
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    // The initialization of the Today tab is asynchronous, so the currentBriefId is not yet available at this point
    if (route.name != TodayTabGroupRouter.name) mainCubit.logTabView(route.name);
    return;
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    mainCubit.logTabView(route.name);
    return;
  }
}
