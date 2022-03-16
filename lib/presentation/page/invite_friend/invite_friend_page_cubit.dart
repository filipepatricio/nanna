import 'package:better_informed_mobile/domain/invite/use_case/get_invite_code_use_case.dart';
import 'package:better_informed_mobile/presentation/page/invite_friend/invite_friend_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class InviteFriendPageCubit extends Cubit<InviteFriendPageState> {
  InviteFriendPageCubit(
    this._getInviteCodeUseCase,
  ) : super(InviteFriendPageState.loading());

  final GetInviteCodeUseCase _getInviteCodeUseCase;

  Future<void> initialize() async {
    emit(InviteFriendPageState.loading());
    
    try {
      final code = await _getInviteCodeUseCase();
      emit(InviteFriendPageState.idle(code));
    } catch (e, s) {
      Fimber.e('Fetching invite code failed', ex: e, stacktrace: s);
      emit(InviteFriendPageState.error());
    }
  }

  Future<void> shareCode() async {}
}
