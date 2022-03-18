import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'no_member_access_page_state.freezed.dart';

@freezed
class NoMemberAccessPageState with _$NoMemberAccessPageState {
  @Implements<BuildState>()
  factory NoMemberAccessPageState.idle() = _NoMemberAccessPageStateIdle;

  factory NoMemberAccessPageState.emailCopied() = _NoMemberAccessPageStateEmailCopied;

  @Implements<BuildState>()
  factory NoMemberAccessPageState.processing() = _NoMemberAccessPageStateProcessing;

  @Implements<BuildState>()
  factory NoMemberAccessPageState.success(bool isOnboardingSeen) = _NoMemberAccessPageStateSuccess;

  factory NoMemberAccessPageState.generalError() = _NoMemberAccessPageStateGeneralError;

  factory NoMemberAccessPageState.noMemberAccess() = _NoMemberAccessPageStateNoMemberAccess;

  factory NoMemberAccessPageState.browserError(String link) = _NoMemberAccessPageStateBrowserError;
}
