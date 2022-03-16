import 'package:freezed_annotation/freezed_annotation.dart';

part 'invite_friend_page_state.freezed.dart';

@freezed
class InviteFriendPageState with _$InviteFriendPageState {
  factory InviteFriendPageState.loading() = _InviteFriendPageStateLoading;

  factory InviteFriendPageState.idle() = _InviteFriendPageStateIdle;
}
