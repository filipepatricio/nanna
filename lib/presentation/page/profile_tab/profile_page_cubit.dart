import 'package:better_informed_mobile/presentation/page/profile_tab/profile_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfilePageCubit extends Cubit<ProfilePageState> {
  ProfilePageCubit() : super(ProfilePageState.initialLoading());

  Future<void> initialize() async {
    emit(ProfilePageState.idle());
  }
}
