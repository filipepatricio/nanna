import 'dart:ui';

import 'package:better_informed_mobile/data/article/database/entity/category_entity.hv.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoryEntityMapper extends BidirectionalMapper<CategoryEntity, Category> {
  @override
  CategoryEntity from(Category data) {
    return CategoryEntity(
      icon: data.icon,
      id: data.id,
      name: data.name,
      slug: data.slug,
      color: data.color?.value,
    );
  }

  @override
  Category to(CategoryEntity data) {
    final colorValue = data.color;

    return Category(
      icon: data.icon,
      id: data.id,
      name: data.name,
      slug: data.slug,
      color: colorValue != null ? Color(colorValue) : null,
    );
  }
}
