import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/tab_bar_cubit.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/tab_bar_state.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/widgets/tab_bar_icon.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

double calculateLastPageShownFactor(ScrollController controller, double listItemsHeight) {
  final listItemsCount = (controller.position.maxScrollExtent / listItemsHeight).round();
  final position = controller.position.pixels + AppDimens.appBarHeight;
  final topicCardsListHeight = (listItemsCount - 1) * listItemsHeight;

  if (position > topicCardsListHeight) {
    final actual = (topicCardsListHeight - position).abs();
    final factor = actual / listItemsHeight;
    return min(factor, 1.0);
  } else {
    return 0.0;
  }
}

void hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

class NoScrollGlow extends NotificationListener<OverscrollIndicatorNotification> {
  NoScrollGlow({required Widget child})
      : super(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return false;
          },
          child: child,
        );
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
  /// Set [activeTab] to implement scrolling to top when on a tab's base page
  const TabBarListener({
    required this.controller,
    required this.currentPage,
    required this.child,
    Key? key,
  }) : super(key: key);

  final ScrollController controller;
  final RouteData currentPage;
  final Widget child;

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
                controller.animateToStart();
              }
            },
            scrollToTop: () {
              if (currentPage.isActive) {
                controller.animateToStart();
              }
            },
            orElse: () {},
          );
        }
      },
    );

    return child;
  }
}
