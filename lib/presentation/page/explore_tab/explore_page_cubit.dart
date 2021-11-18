import 'package:better_informed_mobile/domain/explore/use_case/get_explore_content_use_case.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/explore_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExplorePageCubit extends Cubit<ExplorePageState> {
  final GetExploreContentUseCase _getExploreContentUseCase;

  ExplorePageCubit(this._getExploreContentUseCase) : super(ExplorePageState.initialLoading());

  Future<void> initialize() async {
    try {
      final exploreContent = await _getExploreContentUseCase();
      emit(ExplorePageState.idle(exploreContent.areas));
    } catch (e, s) {
      Fimber.e('Loading explore area failed', ex: e, stacktrace: s);
    }
  }
}
