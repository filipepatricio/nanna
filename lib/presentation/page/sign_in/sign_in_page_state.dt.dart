import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_page_state.dt.freezed.dart';

@freezed
class SignInPageState with _$SignInPageState {
  @Implements<BuildState>()
  factory SignInPageState.idle(bool emailCorrect) = _SignInPageStateIdle;

  @Implements<BuildState>()
  factory SignInPageState.magicLink(String email) = _SignInPageStateMagicLink;

  @Implements<BuildState>()
  factory SignInPageState.processing() = _SignInPageStateProcessing;

  @Implements<BuildState>()
  factory SignInPageState.processingLinkedIn() = _SignInPageStateProcessingLinkedIn;

  factory SignInPageState.success(bool isOnboardingSeen) = _SignInPageStateSuccess;

  factory SignInPageState.unauthorizedError() = _SignInPageStateUnauthorizedError;

  factory SignInPageState.generalError() = _SignInPageStateGeneralError;
}
