import 'package:better_informed_mobile/presentation/page/explore_tab/explore_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExplorePageCubit extends Cubit<ExplorePageState> {
  ExplorePageCubit() : super(ExplorePageState.initialLoading());

  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));

    emit(ExplorePageState.idle());
  }
}
