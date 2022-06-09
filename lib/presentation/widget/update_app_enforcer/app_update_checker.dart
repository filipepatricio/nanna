import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/informed_dialog.dart';
import 'package:better_informed_mobile/presentation/widget/update_app_enforcer/app_update_checker_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/update_app_enforcer/app_update_checker_state.dt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppUpdateChecker extends HookWidget {
  const AppUpdateChecker({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AppUpdateCheckerCubit>();

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    useCubitListener<AppUpdateCheckerCubit, AppUpdateCheckerState>(
      cubit,
      (cubit, state, context) {
        state.maybeMap(
          needsUpdate: (state) => InformedDialog.showAppUpdate(
            context,
            availableVersion: state.availableVersion,
            onWillPop: () async => !(await cubit.shouldUpdate()),
          ),
          orElse: () {},
        );
      },
    );

    useOnAppLifecycleStateChange(
      (previous, current) {
        if (current == AppLifecycleState.resumed) {
          cubit.shouldUpdate();
        }
      },
    );

    return child;
  }
}
