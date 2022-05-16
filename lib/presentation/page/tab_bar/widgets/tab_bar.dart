import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/tab_bar_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/widgets/tab_bar_icon.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _bottomBarElevation = 4.0;

class TabBar extends HookWidget {
  final TabsRouter tabsRouter;

  const TabBar(
    this.tabsRouter, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<TabBarCubit>();

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async => await cubit.getInitialTab().then((initialTab) {
            if (initialTab.isNotEmpty) {
              unawaited(context.navigateNamedTo(initialTab));
            }
          }),
        );
      },
      [cubit],
    );

    return BottomNavigationBar(
      backgroundColor: AppColors.background,
      items: [
        ...MainTab.values.map(
          (tab) => BottomNavigationBarItem(
            icon: tab.icon,
            activeIcon: tab.activeIcon,
            label: tab.title,
          ),
        )
      ],
      elevation: _bottomBarElevation,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == tabsRouter.activeIndex) {
          if (tabsRouter.canPopSelfOrChildren) {
            tabsRouter.popTop();
          } else {
            cubit.tabPressed(MainTabExtension.fromIndex(index));
          }
        }
        tabsRouter.setActiveIndex(index);
      },
      currentIndex: tabsRouter.activeIndex,
    );
  }
}
