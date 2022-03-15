import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/get_bookmark_sort_option_use_case.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/store_last_selected_sort_option_use_case.dart';
import 'package:better_informed_mobile/presentation/page/profile/profile_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfilePageCubit extends Cubit<ProfilePageState> {
  ProfilePageCubit(
    this._getBookmarkSortOptionUseCase,
    this._storeLastSelectedSortOptionUseCase,
  ) : super(ProfilePageState.initializing());

  final GetBookmarkSortOptionUseCase _getBookmarkSortOptionUseCase;
  final StoreLastSelectedSortOptionUseCase _storeLastSelectedSortOptionUseCase;

  Future<void> initialize() async {
    final sortConfig = await _getBookmarkSortOptionUseCase();
    emit(ProfilePageState.idle(BookmarkFilter.all, sortConfig));
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
