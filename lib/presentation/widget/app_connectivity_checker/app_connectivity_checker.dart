import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/app_connectivity_checker/app_connectivity_checker_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/app_connectivity_checker/app_connectivity_checker_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/informed_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppConnectivityChecker extends HookWidget {
  const AppConnectivityChecker({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AppConnectivityCheckerCubit>(closeOnDispose: false);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    useCubitListener<AppConnectivityCheckerCubit, AppConnectivityCheckerState>(
      cubit,
      (cubit, state, context) {
        state.maybeMap(
          notConnected: (state) => InformedDialog.showNoConnection(
            context,
            onWillPop: () async => await cubit.checkIsConnected(),
          ),
          connected: (_) {
            Navigator.of(context, rootNavigator: true).popUntil(
              (route) => route.settings.name != InformedDialog.noConnectionDialogRouteName,
            );
          },
          orElse: () {},
        );
      },
    );

    useOnAppLifecycleStateChange(
      (previous, current) {
        if (current == AppLifecycleState.resumed) {
          cubit.checkIsConnected();
        }
      },
    );

    return child;
  }
}
