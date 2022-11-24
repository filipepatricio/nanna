import 'dart:async';

import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/notify_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/data/category_preference.dart';
import 'package:better_informed_mobile/domain/user/use_case/follow_category_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/get_category_preference_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/unfollow_category_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/category_preference_follow_button/category_preference_follow_button_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

const _briefNotifierDebounceDuration = Duration(seconds: 15);

@injectable
class CategoryPreferenceFollowButtonCubit extends Cubit<CategoryPreferenceFollowButtonState> {
  CategoryPreferenceFollowButtonCubit(
    this._getCategoryPreferenceUseCase,
    this._followCategoryUseCase,
    this._unfollowCategoryUseCase,
    this._updateBriefNotifierUseCase,
  ) : super(const CategoryPreferenceFollowButtonState.loading());

  final UpdateBriefNotifierUseCase _updateBriefNotifierUseCase;
  final GetCategoryPreferenceUseCase _getCategoryPreferenceUseCase;
  final FollowCategoryUseCase _followCategoryUseCase;
  final UnfollowCategoryUseCase _unfollowCategoryUseCase;

  final StreamController<bool> _updateBriefStreamController = StreamController();
  StreamSubscription? _shouldNotifyBriefUpdateSubscription;

  @override
  Future<void> close() async {
    _updateBriefNotifierUseCase();
    await _shouldNotifyBriefUpdateSubscription?.cancel();
    await _updateBriefStreamController.close();
    await super.close();
  }

  Future<void> initialize({Category? category, CategoryPreference? categoryPreference}) async {
    _shouldNotifyBriefUpdateSubscription = _updateBriefStreamController.stream
        .debounceTime(_briefNotifierDebounceDuration)
        .listen((_) => _updateBriefNotifierUseCase());

    if (category != null) {
      emit(const CategoryPreferenceFollowButtonState.loading());
      try {
        final categoryPreference = await _getCategoryPreferenceUseCase(category);
        emit(CategoryPreferenceFollowButtonState.categoryPreferenceLoaded(categoryPreference));
      } catch (e, s) {
        Fimber.e('Getting categories preferences failed', ex: e, stacktrace: s);
      }
    } else if (categoryPreference != null) {
      emit(CategoryPreferenceFollowButtonState.categoryPreferenceLoaded(categoryPreference));
    }
  }

  Future<void> followCategory(CategoryPreference categoryPreference) async {
    try {
      final updatedCategoryPreference = await _followCategoryUseCase(categoryPreference.category);
      _updateBriefStreamController.sink.add(true);
      emit(CategoryPreferenceFollowButtonState.categoryPreferenceLoaded(updatedCategoryPreference));
    } catch (e, s) {
      emit(CategoryPreferenceFollowButtonState.showMessage(LocaleKeys.common_generalError.tr()));
      Fimber.e('Update preferred categories failed', ex: e, stacktrace: s);
    }
  }

  Future<void> unfollowCategory(CategoryPreference categoryPreference) async {
    try {
      final updatedCategoryPreference = await _unfollowCategoryUseCase(categoryPreference.category);
      _updateBriefStreamController.sink.add(true);
      emit(CategoryPreferenceFollowButtonState.categoryPreferenceLoaded(updatedCategoryPreference));
    } catch (e, s) {
      emit(CategoryPreferenceFollowButtonState.showMessage(LocaleKeys.common_generalError.tr()));
      Fimber.e('Update preferred categories failed', ex: e, stacktrace: s);
    }
  }
}
