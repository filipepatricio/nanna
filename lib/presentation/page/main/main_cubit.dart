import 'package:better_informed_mobile/presentation/page/main/main_state.dart';
import 'package:bloc/bloc.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState.init());
}
