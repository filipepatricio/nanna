import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'category_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.categoryEntity)
class CategoryEntity {
  CategoryEntity({
    required this.icon,
    required this.id,
    required this.name,
    required this.slug,
    required this.color,
  });

  @HiveField(0)
  final String icon;
  @HiveField(1)
  final String id;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String slug;
  @HiveField(4)
  final int? color;
}
