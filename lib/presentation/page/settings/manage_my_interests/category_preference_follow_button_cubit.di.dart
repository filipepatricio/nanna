import 'dart:async';

import 'package:better_informed_mobile/domain/categories/data/category_preference.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/notify_brief_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/manage_my_interests/category_preference_follow_button_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoryPreferenceFollowButtonCubit extends Cubit<CategoryPreferenceFollowButtonState> {
  CategoryPreferenceFollowButtonCubit(
    // this._getCategoryPreferencesUseCase,
    this._updateBriefNotifierUseCase,
    // this._followCategoryUseCase,
    // this._unfollowCategoryUseCase,
  ) : super(const CategoryPreferenceFollowButtonState.loading());

  final UpdateBriefNotifierUseCase _updateBriefNotifierUseCase;
  // final FollowCategoryUseCase _followCategoryUseCase;
  // final UnfollowCategoryUseCase _unfollowCategoryUseCase;

  final StreamController<bool> _updateBriefStreamController = StreamController();
  StreamSubscription? _shouldNotifyBriefUpdateSubscription;

  @override
  Future<void> close() async {
    _updateBriefNotifierUseCase();
    await _shouldNotifyBriefUpdateSubscription?.cancel();
    await _updateBriefStreamController.close();
    await super.close();
  }

  Future<void> initialize() async {
    // emit(const CategoryFollowButtonState.loading());
    //
    // _shouldNotifyBriefUpdateSubscription = _updateBriefStreamController.stream
    //     .debounceTime(_briefNotifierDebounceDuration)
    //     .listen((_) => _updateBriefNotifierUseCase());
    //
    // try {
    //   final categoryPreference = await _getCategoryPreferenceUseCase();
    //   emit(CategoryFollowButtonState.categoryPreferenceLoaded(categoryPreference));
    // } catch (e, s) {
    //   Fimber.e('Getting categories preferences failed', ex: e, stacktrace: s);
    // }
  }

  Future<void> followCategory(CategoryPreference categoryPreference) async {
    // try {
    //   final didUpdate = await _followCategoryUseCase(categoryPreference.category);
    //
    //   if (!didUpdate) {
    //     emit(CategoryFollowButtonState.showMessage(LocaleKeys.common_error_body.tr()));
    //
    //     final categoryPreference = await _getCategoryPreferencesUseCase();
    //     emit(CategoryFollowButtonState.categoryPreferenceLoaded(categoryPreference));
    //     return;
    //   }
    //
    //   _updateBriefStreamController.sink.add(true);
    //   emit(CategoryFollowButtonState.categoryPreferenceLoaded(categoryPreference));
    // } catch (e, s) {
    //   Fimber.e('Update preferred categories failed', ex: e, stacktrace: s);
    // }
  }

  Future<void> unfollowCategory(CategoryPreference categoryPreference) async {
    // try {
    //   final didUpdate = await _unfollowCategoryUseCase(categoryPreference.category);
    //
    //   if (!didUpdate) {
    //     emit(CategoryFollowButtonState.showMessage(LocaleKeys.common_error_body.tr()));
    //
    //     final categoryPreference = await _getCategoryPreferencesUseCase();
    //     emit(CategoryFollowButtonState.categoryPreferenceLoaded(categoryPreference));
    //     return;
    //   }
    //
    //   _updateBriefStreamController.sink.add(true);
    //   emit(CategoryFollowButtonState.categoryPreferenceLoaded(categoryPreference));
    // } catch (e, s) {
    //   Fimber.e('Update preferred categories failed', ex: e, stacktrace: s);
    // }
  }
}
