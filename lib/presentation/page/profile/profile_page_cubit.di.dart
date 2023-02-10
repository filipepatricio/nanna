import 'dart:async';

import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/get_bookmark_sort_option_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/store_last_selected_sort_option_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/profile/profile_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfilePageCubit extends Cubit<ProfilePageState> {
  ProfilePageCubit(
    this._getBookmarkSortOptionUseCase,
    this._storeLastSelectedSortOptionUseCase,
    this._getActiveSubscriptionUseCase,
  ) : super(ProfilePageState.initializing());

  final GetBookmarkSortOptionUseCase _getBookmarkSortOptionUseCase;
  final StoreLastSelectedSortOptionUseCase _storeLastSelectedSortOptionUseCase;
  final GetActiveSubscriptionUseCase _getActiveSubscriptionUseCase;

  late bool _hasActiveSubscription;

  StreamSubscription<ActiveSubscription>? _activeSubscriptionSub;

  @override
  Future<void> close() async {
    await _activeSubscriptionSub?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    final sortConfig = await _getBookmarkSortOptionUseCase();
    _hasActiveSubscription = (await _getActiveSubscriptionUseCase()).isPremium;

    emit(ProfilePageState.idle(BookmarkFilter.all, sortConfig, _hasActiveSubscription));

    _activeSubscriptionSub = _getActiveSubscriptionUseCase.stream.listen((subscription) async {
      _hasActiveSubscription = subscription.isPremium;

      state.mapOrNull(
        idle: (state) {
          emit(
            state.copyWith(
              version: state.version + 1,
              hasActiveSubscription: _hasActiveSubscription,
            ),
          );
        },
      );
    });
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
