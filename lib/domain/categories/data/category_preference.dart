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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryPreference && other.isPreferred == isPreferred && other.category == category;
  }

  @override
  int get hashCode => isPreferred.hashCode ^ category.hashCode;

  @override
  String toString() => 'CategoryPreference(isPreferred: $isPreferred, category: $category)';
}
