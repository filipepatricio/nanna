import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_categories_slide_data.dt.freezed.dart';

@Freezed(toJson: false)
class OnboardingCategoriesSlideData with _$OnboardingCategoriesSlideData {
  factory OnboardingCategoriesSlideData({
    required List<Category> categories,
    required List<Category> selectedCategories,
  }) = _OnboardingCategoriesSlideData;

  factory OnboardingCategoriesSlideData.emptyData() => _OnboardingCategoriesSlideData(
        categories: [],
        selectedCategories: [],
      );
}
