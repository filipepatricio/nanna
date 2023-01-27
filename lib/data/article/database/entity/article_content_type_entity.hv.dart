import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'article_content_type_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.articleContentTypeEntity)
class ArticleContentTypeEntity {
  ArticleContentTypeEntity({required this.name});

  @HiveField(0)
  final String name;
}
