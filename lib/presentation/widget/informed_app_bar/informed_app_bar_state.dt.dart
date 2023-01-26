import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'informed_app_bar_state.dt.freezed.dart';

@Freezed(toJson: false)
class InformedAppBarState with _$InformedAppBarState {
  @Implements<BuildState>()
  factory InformedAppBarState.idle() = _InformedAppBarStateIdle;

  @Implements<BuildState>()
  factory InformedAppBarState.noConnection() = _InformedAppBarStateNoConnection;
}
