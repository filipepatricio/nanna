import 'package:better_informed_mobile/domain/categories/data/category.dt.dart';
import 'package:better_informed_mobile/domain/categories/use_case/get_onboarding_categories_use_case.di.dart';
import 'package:better_informed_mobile/domain/categories/use_case/set_selected_onboarding_categories_stream_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/slides/onboarding_categories_slide/onboarding_categories_slide_data.dt.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/slides/onboarding_categories_slide/onboarding_categories_slide_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class OnboardingCategoriesSlideCubit extends Cubit<OnboardingCategoriesSlideState> {
  OnboardingCategoriesSlideCubit(
    this._getOnboardingCategoriesUseCase,
    this._setSelectedOnboardingCategoriesStreamUseCase,
  ) : super(const OnboardingCategoriesSlideState.loading());

  final GetOnboardingCategoriesUseCase _getOnboardingCategoriesUseCase;
  final SetSelectedOnboardingCategoriesStreamUseCase _setSelectedOnboardingCategoriesStreamUseCase;

  OnboardingCategoriesSlideData _data = OnboardingCategoriesSlideData.emptyData();

  Future<void> init() async {
    try {
      final categories = await _getOnboardingCategoriesUseCase();
      final selectedCategories = await _getOnboardingCategoriesUseCase.stream.first;
      _data = _data.copyWith(
        categories: categories,
        selectedCategories: selectedCategories,
      );
    } catch (e, s) {
      Fimber.e('Onboarding categories loading failed', ex: e, stacktrace: s);
      emit(const OnboardingCategoriesSlideState.error());
    }
    _updateState();
  }

  void _updateState({bool selectedCategoriesChanged = false}) {
    emit(OnboardingCategoriesSlideState.idle(data: _data));
    if (selectedCategoriesChanged) {
      _setSelectedOnboardingCategoriesStreamUseCase(_data.selectedCategories);
    }
  }

  void onAllCardPressed() {
    if (_data.selectedCategories.isNotEmpty) {
      _data = _data.copyWith(selectedCategories: []);
      _updateState(selectedCategoriesChanged: true);
    }
  }

  void onCardPressed(Category category) {
    if (_data.selectedCategories.contains(category)) {
      final newSelectedCategories = List<Category>.from(_data.selectedCategories);
      newSelectedCategories.remove(category);
      _data = _data.copyWith(selectedCategories: newSelectedCategories);
      _updateState(selectedCategoriesChanged: true);
    } else {
      _data = _data.copyWith(selectedCategories: [..._data.selectedCategories, category]);
      _updateState(selectedCategoriesChanged: true);
    }
  }
}
