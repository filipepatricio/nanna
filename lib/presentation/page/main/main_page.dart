import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/main/main_cubit.dart';
import 'package:better_informed_mobile/presentation/page/main/main_state.dart';
import 'package:better_informed_mobile/presentation/page/main/widgets/bottom_navigation.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MainPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<MainCubit>();
    final state = useCubitBuilder<MainCubit, MainState>(cubit);

    return state.maybeWhen(
      init: () => AutoTabsScaffold(
        animationDuration: const Duration(),
        extendBody: false,
        routes: const [
          TodayTabGroupRouter(),
          ExploreTabGroupRouter(),
          MyReadsTabGroupRouter(),
        ],
        bottomNavigationBuilder: (context, tabsRouter) => BottomNavigation(state, cubit, tabsRouter),
      ),
      orElse: () => Container(),
    );
  }
}
