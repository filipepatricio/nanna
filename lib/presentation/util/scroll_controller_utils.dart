import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/tab_bar_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/tab_bar_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/widgets/tab_bar_icon.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

class NoScrollGlow extends NotificationListener<OverscrollIndicatorNotification> {
  const NoScrollGlow({required Widget child})
      : super(
          onNotification: noOverscroll,
          child: child,
        );

  static bool noOverscroll(OverscrollIndicatorNotification overscroll) {
    overscroll.disallowIndicator();
    return false;
  }
}

extension BackToTop on ScrollController {
  Future<void> animateToStart() async {
    if (hasClients) {
      return await animateTo(
        positions.first.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }
  }
}

class TabBarListener extends HookWidget {
  /// Widget to listen to TabBarCubit states.
  ///
  /// Used to implement scrolling to top on [MainTab] icon tap or status bar tap (iOS's scroll to top)
  ///
  /// Set activeTab to implement scrolling to top when on a tab's base page
  const TabBarListener({
    required this.scrollController,
    required this.currentPage,
    required this.child,
    this.onTabSelected,
    Key? key,
  }) : super(key: key);

  final ScrollController scrollController;
  final RouteData currentPage;
  final Widget child;
  final VoidCallback? onTabSelected;

  @override
  Widget build(BuildContext context) {
    final isMounted = useIsMounted();
    final cubit = useCubit<TabBarCubit>(closeOnDispose: false);

    useCubitListener<TabBarCubit, TabBarState>(
      cubit,
      (cubit, state, context) {
        if (isMounted()) {
          state.maybeWhen(
            tabPressed: (tab) {
              if (currentPage.isActive && tab == MainTabExtension.fromIndex(context.tabsRouter.activeIndex)) {
                scrollController.animateToStart();
              }
              final onTabSelected = this.onTabSelected;
              onTabSelected?.call();
            },
            orElse: () {},
          );
        }
      },
    );

    return child;
  }
}
