import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.dt.freezed.dart';

@freezed
class Category with _$Category {
  const factory Category({
    required String name,
    required String id,
    required String slug,
    required String icon,
    required List<CategoryItem> items,
  }) = _Category;
}
