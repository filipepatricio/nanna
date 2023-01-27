import 'package:better_informed_mobile/data/article/database/entity/article_audio_file_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/article_content_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/article_header_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'article_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.articleEntity)
class ArticleEntity {
  ArticleEntity({
    required this.header,
    required this.content,
    required this.audioFile,
  });

  @HiveField(0)
  final ArticleHeaderEntity header;
  @HiveField(1)
  final ArticleContentEntity content;
  @HiveField(2)
  final ArticleAudioFileEntity? audioFile;
}
