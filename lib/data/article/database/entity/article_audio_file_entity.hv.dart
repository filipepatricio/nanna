import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'article_audio_file_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.articleAudioFileEntity)
class ArticleAudioFileEntity {
  ArticleAudioFileEntity({
    required this.url,
    required this.credits,
  });

  @HiveField(0)
  final String url;
  @HiveField(1)
  final String? credits;
}
