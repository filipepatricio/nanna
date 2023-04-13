import 'package:better_informed_mobile/domain/legal_page/data/legal_page.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_legal_page_state.dt.freezed.dart';

@Freezed(toJson: false)
class SettingsLegalPageState with _$SettingsLegalPageState {
  @Implements<BuildState>()
  const factory SettingsLegalPageState.loading() = _SettingsLegalPageStateLoading;

  @Implements<BuildState>()
  const factory SettingsLegalPageState.idle(LegalPage page) = _SettingsLegalPageStateIdle;

  @Implements<BuildState>()
  const factory SettingsLegalPageState.error() = _SettingsLegalPageStateError;
}
