import 'package:better_informed_mobile/domain/invite/data/invite_code.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'invite_friend_page_state.dt.freezed.dart';

@freezed
class InviteFriendPageState with _$InviteFriendPageState {
  @Implements<BuildState>()
  factory InviteFriendPageState.loading() = _InviteFriendPageStateLoading;

  @Implements<BuildState>()
  factory InviteFriendPageState.idle(InviteCode code) = _InviteFriendPageStateIdle;

  @Implements<BuildState>()
  factory InviteFriendPageState.error() = _InviteFriendPageStateError;

  factory InviteFriendPageState.codeCopied() = _InviteFriendPageStateCodeCopied;
}
