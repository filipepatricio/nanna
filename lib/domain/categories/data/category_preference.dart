import 'package:better_informed_mobile/domain/categories/data/category.dart';

class CategoryPreference {
  const CategoryPreference({
    required this.isPreferred,
    required this.category,
  });

  final bool isPreferred;
  final Category category;

  CategoryPreference copyWith({
    bool? isPreferred,
    Category? category,
  }) {
    return CategoryPreference(
      isPreferred: isPreferred ?? this.isPreferred,
      category: category ?? this.category,
    );
  }
}
