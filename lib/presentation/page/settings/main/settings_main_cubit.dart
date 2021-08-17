import 'package:better_informed_mobile/domain/auth/use_case/sign_out_use_case.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_state.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettingsMainCubit extends Cubit<SettingsMainState> {
  final SignOutUseCase _signOutUseCase;

  SettingsMainCubit(this._signOutUseCase) : super(const SettingsMainState.init());

  Future<void> signOut() async {
    emit(const SettingsMainState.loading());

    try {
      await _signOutUseCase();
      emit(const SettingsMainState.signedOut());
    } catch (e, s) {
      Fimber.e('Signing out failed', ex: e, stacktrace: s);
      emit(const SettingsMainState.init());
    }
  }
}
