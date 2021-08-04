import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_state.dart';
import 'package:bloc/bloc.dart';

class SettingsMainCubit extends Cubit<SettingsMainState> {
  SettingsMainCubit() : super(const SettingsMainState.init());

  Future<void> signOut() async {
    //TODO: SIGN OUT
  }
}
