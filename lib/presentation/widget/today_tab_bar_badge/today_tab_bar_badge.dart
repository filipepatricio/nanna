import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/today_tab_bar_badge/today_tab_bar_badge_cubit.di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TodayTabBarBadge extends HookWidget {
  const TodayTabBarBadge({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<TodayTabBarBadgeCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return state.map(
      initializing: (_) => child,
      idle: (state) => Badge.count(
        count: state.unseenCount,
        isLabelVisible: state.unseenCount > 0,
        child: child,
      ),
    );
  }
}
