import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/dashboard/dashboard_cubit.dart';
import 'package:better_informed_mobile/presentation/page/dashboard/dashboard_state.dart';
import 'package:better_informed_mobile/presentation/page/dashboard/widgets/bottom_navigation.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DashboardPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<DashboardCubit>();
    final state = useCubitBuilder<DashboardCubit, DashboardState>(cubit);

    return state.maybeWhen(
      init: () => AutoTabsScaffold(
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
