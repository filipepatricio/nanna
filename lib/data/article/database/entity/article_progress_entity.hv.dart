import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'article_progress_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.articleProgressEntity)
class ArticleProgressEntity {
  ArticleProgressEntity({
    required this.audioPosition,
    required this.audioProgress,
    required this.contentProgress,
  });

  @HiveField(0)
  final int audioPosition;
  @HiveField(1)
  final int audioProgress;
  @HiveField(2)
  final int contentProgress;
}
