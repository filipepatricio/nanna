import 'dart:ui';

import 'package:better_informed_mobile/domain/categories/data/category_with_items.dart';

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
    required this.color,
  });

  final String name;
  final String id;
  final String slug;
  final String icon;
  final Color? color;

  CategoryWithItems asCategoryWithItems() => CategoryWithItems(
        id: id,
        name: name,
        slug: slug,
        icon: icon,
        color: color,
        items: [],
      );
}
