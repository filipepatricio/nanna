import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/app_connectivity_checker/app_connectivity_checker_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/app_connectivity_checker/app_connectivity_checker_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/informed_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppConnectivityChecker extends HookWidget {
  const AppConnectivityChecker({
    required this.child,
    this.closeCubitOnDispose = false,
  });

  final bool closeCubitOnDispose;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isMounted = useIsMounted();
    final lifecycleState = useAppLifecycleState();
    final cubit = useCubit<AppConnectivityCheckerCubit>(closeOnDispose: closeCubitOnDispose);

    AppConnectivityCheckerState? currentState;

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
          notConnected: (newState) {
            currentState = newState;
            if ((isMounted() && lifecycleState == AppLifecycleState.resumed) || kIsTest) {
              InformedDialog.showNoConnection(
                context,
                onWillPop: cubit.checkIsConnected,
              );
            }
            return;
          },
          connected: (newState) {
            if (currentState == const AppConnectivityCheckerState.notConnected()) {
              Navigator.of(context, rootNavigator: true).popUntil(
                (route) => route.settings.name != InformedDialog.noConnectionDialogRouteName,
              );
            }
            currentState = newState;
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
