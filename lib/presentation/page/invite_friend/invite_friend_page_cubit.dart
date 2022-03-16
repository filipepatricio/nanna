import 'package:better_informed_mobile/presentation/page/invite_friend/invite_friend_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class InviteFriendPageCubit extends Cubit<InviteFriendPageState> {
  InviteFriendPageCubit() : super(InviteFriendPageState.loading());

  Future<void> initialize() async {
    
  }

  Future<void> shareCode() async {}
}
