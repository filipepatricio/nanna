import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'article_kind_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.articleKindEntity)
class ArticleKindEntity {
  ArticleKindEntity({required this.name});

  @HiveField(0)
  final String name;
}
