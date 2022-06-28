import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/get_bookmark_sort_option_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/store_last_selected_sort_option_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/set_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/profile/profile_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfilePageCubit extends Cubit<ProfilePageState> {
  ProfilePageCubit(
    this._getBookmarkSortOptionUseCase,
    this._storeLastSelectedSortOptionUseCase,
    this._isTutorialStepSeenUseCase,
    this._setTutorialStepSeenUseCase,
  ) : super(ProfilePageState.initializing());

  final GetBookmarkSortOptionUseCase _getBookmarkSortOptionUseCase;
  final StoreLastSelectedSortOptionUseCase _storeLastSelectedSortOptionUseCase;
  final IsTutorialStepSeenUseCase _isTutorialStepSeenUseCase;
  final SetTutorialStepSeenUseCase _setTutorialStepSeenUseCase;

  Future<void> initialize() async {
    final sortConfig = await _getBookmarkSortOptionUseCase();
    emit(ProfilePageState.idle(BookmarkFilter.all, sortConfig));

    final isProfileTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.profile);
    if (!isProfileTutorialStepSeen) {
      emit(ProfilePageState.showTutorialToast(LocaleKeys.tutorial_profileSnackBarText.tr()));
      await _setTutorialStepSeenUseCase(TutorialStep.profile);
    }
  }

  void changeFilter(BookmarkFilter filter) {
    state.mapOrNull(
      idle: (state) => emit(state.copyWith(filter: filter)),
    );
  }

  Future<void> changeSortConfig(BookmarkSortConfigName sortConfig) async {
    state.mapOrNull(
      idle: (state) => emit(state.copyWith(sortConfigName: sortConfig)),
    );
    await _storeLastSelectedSortOptionUseCase(sortConfig);
  }
}
