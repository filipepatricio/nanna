import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/tab_bar_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/widgets/tab_bar_icon.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum InformedTabBarMode { fixed, floating }

class InformedTabBar extends HookWidget {
  const InformedTabBar._({
    this.router,
    this.mode = InformedTabBarMode.fixed,
    Key? key,
  }) : super(key: key);

  factory InformedTabBar.fixed({required TabsRouter router}) => InformedTabBar._(
        router: router,
        mode: InformedTabBarMode.fixed,
      );

  final TabsRouter? router;
  final InformedTabBarMode mode;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<TabBarCubit>(closeOnDispose: false);

    useEffect(
      () {
        cubit.initialize(router!);
      },
      [router],
    );

    return _TabBar(
      currentIndex: router!.activeIndex,
      onTap: (index) {
        if (index == router!.activeIndex) {
          if (context.tabsRouter.canPop()) {
            context.router.popTop();
          } else {
            cubit.tabPressed(MainTabExtension.fromIndex(index));
          }
        }
        cubit.setTab(index);
      },
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.currentIndex,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'tabs',
      transitionOnUserGestures: true,
      child: _InformedAppBarShadow(
        child: BottomNavigationBar(
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
          type: BottomNavigationBarType.fixed,
          onTap: onTap,
          currentIndex: currentIndex,
        ),
      ),
    );
  }
}

class _InformedAppBarShadow extends StatelessWidget {
  const _InformedAppBarShadow({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.black04,
            blurRadius: 4,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: child,
    );
  }
}
