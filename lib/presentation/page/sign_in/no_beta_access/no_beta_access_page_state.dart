import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'no_beta_access_page_state.freezed.dart';

@freezed
class NoBetaAccessPageState with _$NoBetaAccessPageState {
  @Implements<BuildState>()
  factory NoBetaAccessPageState.idle() = _NoBetaAccessPageStateIdle;

  factory NoBetaAccessPageState.emailCopied() = _NoBetaAccessPageStateEmailCopied;

  factory NoBetaAccessPageState.browserError(String link) = _NoBetaAccessPageStateBrowserError;
}
