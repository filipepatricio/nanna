import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_connectivity_checker_state.dt.freezed.dart';

@freezed
class AppConnectivityCheckerState with _$AppConnectivityCheckerState {
  @Implements<BuildState>()
  factory AppConnectivityCheckerState.connected() = _AppConnectivityCheckerStateIdle;

  const factory AppConnectivityCheckerState.notConnected() = _AppConnectivityCheckerStateNoConnection;
}
