import 'package:better_informed_mobile/data/article/database/entity/article_content_type_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'article_content_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.articleContentEntity)
class ArticleContentEntity {
  ArticleContentEntity({
    required this.content,
    required this.credits,
    required this.type,
  });

  @HiveField(0)
  final String content;
  @HiveField(1)
  final String credits;
  @HiveField(2)
  final ArticleContentTypeEntity type;
}
