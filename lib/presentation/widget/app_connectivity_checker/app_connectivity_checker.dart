import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/types.dart';
import 'package:better_informed_mobile/presentation/widget/app_connectivity_checker/app_connectivity_checker_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/app_connectivity_checker/app_connectivity_checker_state.dt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class AppConnectivityChecker extends HookWidget {
  const AppConnectivityChecker({
    required this.child,
    this.closeCubitOnDispose = false,
  });

  final bool closeCubitOnDispose;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AppConnectivityCheckerCubit>(closeOnDispose: closeCubitOnDispose);
    final state = useCubitBuilder<AppConnectivityCheckerCubit, AppConnectivityCheckerState>(cubit);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    useOnAppLifecycleStateChange(
      (previous, current) {
        if (current == AppLifecycleState.resumed) {
          cubit.checkIsConnected();
        }
      },
    );

    return Provider<IsConnected>.value(
      value: state.map(
        connected: (_) => true,
        notConnected: (_) => false,
      ),
      child: child,
    );
  }
}
