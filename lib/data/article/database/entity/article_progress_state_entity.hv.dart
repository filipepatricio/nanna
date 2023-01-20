import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'article_progress_state_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.articleProgressStateEntity)
class ArticleProgressStateEntity {
  ArticleProgressStateEntity({required this.name});

  @HiveField(0)
  final String name;
}
