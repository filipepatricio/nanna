import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'article_type_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.articleTypeEntity)
class ArticleTypeEntity {
  ArticleTypeEntity({required this.name});

  @HiveField(0)
  final String name;
}
