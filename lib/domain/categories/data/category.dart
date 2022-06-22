import 'package:better_informed_mobile/domain/general/result_item.dt.dart';

class Category {
  const Category({
    required this.name,
    required this.id,
    required this.slug,
    required this.icon,
    this.items,
  });

  final String icon;
  final String id;
  final String name;
  final String slug;
  final List<ResultItem>? items;
}
