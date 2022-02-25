import 'package:better_informed_mobile/presentation/page/tab_bar/tab_bar_state.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/widgets/tab_bar_icon.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TabBarCubit extends Cubit<TabBarState> {
  TabBarCubit() : super(const TabBarState.init());

  void tabPressed(MainTab tab) {
    emit(const TabBarState.init());
    emit(TabBarState.tabPressed(tab));
  }
}
