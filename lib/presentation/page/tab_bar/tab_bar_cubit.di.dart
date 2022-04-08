import 'package:better_informed_mobile/presentation/page/tab_bar/tab_bar_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/widgets/tab_bar_icon.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TabBarCubit extends Cubit<TabBarState> {
  TabBarCubit() : super(const TabBarState.idle());

  void tabPressed(MainTab tab) {
    emit(TabBarState.tabPressed(tab));
    emit(const TabBarState.idle());
  }

  void scrollToTop() {
    emit(const TabBarState.scrollToTop());
    emit(const TabBarState.idle());
  }
}
