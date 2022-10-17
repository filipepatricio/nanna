import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';

class CategoryWithItems extends Category {
  CategoryWithItems({
    required super.id,
    required super.name,
    required super.slug,
    required super.icon,
    required super.color,
    required this.items,
  });

  factory CategoryWithItems.fromCategory(Category category) => CategoryWithItems(
        id: category.id,
        name: category.name,
        slug: category.slug,
        icon: category.icon,
        color: category.color,
        items: <CategoryItem>[],
      );

  final List<CategoryItem> items;
}
