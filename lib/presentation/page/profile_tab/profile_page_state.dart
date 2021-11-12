import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_page_state.freezed.dart';

@freezed
class ProfilePageState with _$ProfilePageState {
  @Implements(BuildState)
  factory ProfilePageState.initialLoading() = _ProfilePageStateInitialLoading;

  @Implements(BuildState)
  factory ProfilePageState.idle() = _ProfilePageStateIdle;
}
