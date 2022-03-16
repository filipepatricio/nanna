import 'package:better_informed_mobile/core/util/app_link.dart';
import 'package:better_informed_mobile/domain/invite/use_case/get_invite_code_use_case.dart';
import 'package:better_informed_mobile/domain/share/use_case/share_text_use_case.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/invite_friend/invite_friend_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@injectable
class InviteFriendPageCubit extends Cubit<InviteFriendPageState> {
  InviteFriendPageCubit(
    this._getInviteCodeUseCase,
    this._shareTextUseCase,
  ) : super(InviteFriendPageState.loading());

  final GetInviteCodeUseCase _getInviteCodeUseCase;
  final ShareTextUseCase _shareTextUseCase;

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

  Future<void> copyCode() async {
    await state.mapOrNull(
      idle: (state) async {
        await Clipboard.setData(ClipboardData(text: state.code.code));
        emit(InviteFriendPageState.codeCopied());
        emit(state);
      },
    );
  }

  Future<void> shareCode() async {
    await state.mapOrNull(
      idle: (state) async {
        final shareText = tr(
          LocaleKeys.inviteFriend_shareText,
          args: [
            state.code.code,
            platformStoreLink,
          ],
        );
        await _shareTextUseCase(shareText);
      },
    );
  }
}
