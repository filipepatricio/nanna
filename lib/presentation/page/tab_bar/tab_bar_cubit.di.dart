import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/get_initial_tab_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/tab_bar_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/widgets/tab_bar_icon.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TabBarCubit extends Cubit<TabBarState> {
  TabBarCubit(this._getInitialTabUseCase) : super(const TabBarState.idle());

  final GetInitialTabUseCase _getInitialTabUseCase;

  late TabsRouter _currentTabsRouter;

  int get activeIndex => _currentTabsRouter.activeIndex;

  void initialize(TabsRouter router) {
    _currentTabsRouter = router;
  }

  void setTab(int index) {
    _currentTabsRouter.setActiveIndex(index);
  }

  Future<String> getInitialTab() async {
    return await _getInitialTabUseCase();
  }

  void tabPressed(MainTab tab) {
    emit(TabBarState.tabPressed(tab));
    emit(const TabBarState.idle());
  }

  void scrollToTop() {
    emit(const TabBarState.scrollToTop());
    emit(const TabBarState.idle());
  }
}
