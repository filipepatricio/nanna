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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarDividerColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: AutoTabsScaffold(
        animationDuration: const Duration(),
        routes: const [
          TodayTabGroupRouter(),
          ExploreTabGroupRouter(),
          MyReadsTabGroupRouter(),
        ],
        bottomNavigationBuilder: (context, tabsRouter) => BottomNavigation(
          state,
          cubit,
          tabsRouter,
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
