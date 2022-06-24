import 'package:better_informed_mobile/domain/categories/data/category_preference.dart';
import 'package:better_informed_mobile/domain/categories/use_case/get_category_preferences_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/update_preferred_categories_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/manage_my_interests/settings_manage_my_interests_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettingsManageMyInterestsCubit extends Cubit<SettingsManageMyInterestsState> {
  final GetCategoryPreferencesUseCase _getCategoryPreferencesUseCase;
  final UpdatePreferredCategoriesUseCase _updatePreferredCategoriesUseCase;

  SettingsManageMyInterestsCubit(
    this._getCategoryPreferencesUseCase,
    this._updatePreferredCategoriesUseCase,
  ) : super(const SettingsManageMyInterestsState.loading());

  Future<void> initialize() async {
    emit(const SettingsManageMyInterestsState.loading());

    try {
      final categoryPreferences = await _getCategoryPreferencesUseCase();
      emit(SettingsManageMyInterestsState.myInterestsSettingsLoaded(categoryPreferences));
    } catch (e, s) {
      Fimber.e('Getting categories preferences failed', ex: e, stacktrace: s);
    }
  }

  Future<void> updatePreferredCategories(List<CategoryPreference> categoryPreferences) async {
    try {
      await _updatePreferredCategoriesUseCase(
        categoryPreferences.where((e) => e.isPreferred).map((e) => e.category).toList(),
      );

      emit(SettingsManageMyInterestsState.myInterestsSettingsLoaded(categoryPreferences));
    } catch (e, s) {
      Fimber.e('Update preferred categories failed', ex: e, stacktrace: s);
    }
  }
}
