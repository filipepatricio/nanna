import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/presentation/page/main/main_cubit.dart';
import 'package:better_informed_mobile/presentation/page/main/main_state.dart';
import 'package:better_informed_mobile/presentation/page/main/widgets/bottom_navigation_icon.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _bottomBarElevation = 4.0;

class BottomNavigation extends HookWidget {
  final MainState state;
  final MainCubit cubit;
  final TabsRouter tabsRouter;

  const BottomNavigation(
    this.state,
    this.cubit,
    this.tabsRouter, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state.maybeWhen(
      init: () => BottomNavigationBar(
        backgroundColor: AppColors.lightGrey,
        items: [
          ...MainTabs.values.map(
            (tab) => BottomNavigationBarItem(
              icon: tab.icon,
              activeIcon: tab.activeIcon,
              label: tab.title,
            ),
          )
        ],
        elevation: _bottomBarElevation,
        type: BottomNavigationBarType.fixed,
        onTap: tabsRouter.setActiveIndex,
        currentIndex: tabsRouter.activeIndex,
      ),
      orElse: () => const SizedBox(),
    );
  }
}
