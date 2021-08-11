import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_page_state.freezed.dart';

@freezed
class SignInPageState with _$SignInPageState {
  @Implements(BuildState)
  factory SignInPageState.idle(bool emailCorrect) = _SignInPageStateIdle;

  @Implements(BuildState)
  factory SignInPageState.magicLink() = _SignInPageStateMagicLink;
}
