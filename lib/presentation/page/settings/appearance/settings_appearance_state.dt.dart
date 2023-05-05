import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_appearance_state.dt.freezed.dart';

@Freezed(toJson: false)
class SettingsAppearanceState with _$SettingsAppearanceState {
  @Implements<BuildState>()
  const factory SettingsAppearanceState.init() = _SettingsAppearanceStateInit;

  @Implements<BuildState>()
  const factory SettingsAppearanceState.idle({
    required double preferredArticleTextScaleFactor,
    required bool showTextScaleFactorSelector,
  }) = _SettingsAppearanceStateIdle;
}
