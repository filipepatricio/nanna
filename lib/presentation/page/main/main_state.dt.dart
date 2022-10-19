import 'package:better_informed_mobile/domain/release_notes/data/release_note.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_state.dt.freezed.dart';

@Freezed(toJson: false)
class MainState with _$MainState {
  @Implements<BuildState>()
  const factory MainState.init() = MainStateInit;

  const factory MainState.tokenExpired() = _MainStateTokenExpired;

  const factory MainState.navigate(String path) = _MainStateNavigate;

  const factory MainState.multiNavigate(List<String> path) = __MainStateMultiNavigate;

  const factory MainState.showReleaseNote(ReleaseNote releaseNote) = _MainStateShowReleaseNote;

  const factory MainState.resetRouteStack() = _MainStateResetRouteStack;
}
