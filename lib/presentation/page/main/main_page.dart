import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/core/di/di_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/main/main_cubit.dart';
import 'package:better_informed_mobile/presentation/page/main/main_state.dart';
import 'package:better_informed_mobile/presentation/page/main/widgets/bottom_navigation.dart';
import 'package:better_informed_mobile/presentation/routing/observers/tabs_navigation_observer.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

final mainPageKey = GlobalKey();

class MainPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<MainCubit>();
    final state = useCubitBuilder<MainCubit, MainState>(cubit);

    useCubitListener<MainCubit, MainState>(cubit, (cubit, state, context) {
      state.maybeMap(
        tokenExpired: (_) => _onTokenExpiredEvent(context),
        navigate: (navigate) async {
          await closeWebView();
          await context.navigateNamedTo(
            const MainPageRoute().path + navigate.path,
            onFailure: (failure) {
              Fimber.e('Incoming push - navigation failed', ex: failure);
            },
          );
        },
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
            bottomNavigationBuilder: (context, tabsRouter) => BottomNavigation(state, cubit, tabsRouter),
            navigatorObservers: () => [getIt<TabsNavigationObserver>()]),
      ),
    );
  }

  void _onTokenExpiredEvent(BuildContext context) {
    AutoRouter.of(context).replaceAll([const SignInPageRoute()]);
  }
}
