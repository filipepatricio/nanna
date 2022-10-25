import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/tab_bar_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/widgets/tab_bar_icon.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum InformedTabBarMode { fixed, floating }

class InformedTabBar extends HookWidget {
  const InformedTabBar._({
    this.router,
    this.mode = InformedTabBarMode.fixed,
    this.show = true,
    Key? key,
  }) : super(key: key);

  factory InformedTabBar.fixed({required TabsRouter router}) => InformedTabBar._(
        router: router,
        mode: InformedTabBarMode.fixed,
      );
  factory InformedTabBar.floating({required bool show}) => InformedTabBar._(
        mode: InformedTabBarMode.floating,
        show: show,
      );

  final TabsRouter? router;
  final InformedTabBarMode mode;
  final bool show;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<TabBarCubit>(closeOnDispose: false);

    if (mode == InformedTabBarMode.floating) {
      return AnimatedPositioned(
        // Adding up bottom padding to ensure bar is hidden below iPhone Dock
        bottom: show ? 0 : -(AppDimens.xxc + MediaQuery.of(context).viewPadding.bottom),
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 200),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: _TabBar(
            currentIndex: cubit.activeIndex,
            onTap: (index) {
              context.router.popUntilRoot();
              cubit.setTab(index);
            },
          ),
        ),
      );
    }

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
