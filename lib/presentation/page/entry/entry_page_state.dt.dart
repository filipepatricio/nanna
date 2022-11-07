import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'entry_page_state.dt.freezed.dart';

@Freezed(toJson: false)
class EntryPageState with _$EntryPageState {
  @Implements<BuildState>()
  factory EntryPageState.idle() = _EntryPageStateIdle;

  @Implements<BuildState>()
  factory EntryPageState.error() = _EntryPageStateError;

  factory EntryPageState.alreadySignedIn() = _EntryPageStateAlreadySignedIn;

  factory EntryPageState.notSignedIn() = _EntryPageStateNotSignedIn;

  factory EntryPageState.onboarding() = _EntryPageStateOnboarding;
}
