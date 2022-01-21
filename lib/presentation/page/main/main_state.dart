import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_state.freezed.dart';

@freezed
class MainState with _$MainState {
  @Implements<BuildState>()
  const factory MainState.init() = MainStateInit;

  const factory MainState.tokenExpired() = _MainStateTokenExpired;

  const factory MainState.navigate(String path) = _MainStateNavigate;
}
