import 'package:better_informed_mobile/data/article/database/entity/article_image_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/article_kind_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/article_progress_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/article_progress_state_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/article_type_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/category_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/curation_info_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/publisher_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'article_header_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.articleHeaderEntity)
class ArticleHeaderEntity {
  ArticleHeaderEntity({
    required this.id,
    required this.slug,
    required this.url,
    required this.title,
    required this.strippedTitle,
    required this.note,
    required this.type,
    required this.kind,
    required this.publicationDate,
    required this.timeToRead,
    required this.publisher,
    required this.image,
    required this.sourceUrl,
    required this.author,
    required this.hasAudioVersion,
    required this.availableInSubscription,
    required this.progress,
    required this.progressState,
    required this.locked,
    required this.category,
    required this.curationInfo,
    required this.isNoteCollapsible,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String slug;
  @HiveField(2)
  final String url;
  @HiveField(3)
  final String title;
  @HiveField(4)
  final String strippedTitle;
  @HiveField(5)
  final String? note;
  @HiveField(6)
  final ArticleTypeEntity type;
  @HiveField(7)
  final ArticleKindEntity? kind;
  @HiveField(8)
  final String? publicationDate;
  @HiveField(9)
  final int? timeToRead;
  @HiveField(10)
  final PublisherEntity publisher;
  @HiveField(11)
  final ArticleImageEntity? image;
  @HiveField(12)
  final String sourceUrl;
  @HiveField(13)
  final String? author;
  @HiveField(14)
  final bool hasAudioVersion;
  @HiveField(15)
  final bool availableInSubscription;
  @HiveField(16)
  final ArticleProgressEntity progress;
  @HiveField(17)
  final ArticleProgressStateEntity progressState;
  @HiveField(18)
  final bool locked;
  @HiveField(19)
  final CategoryEntity category;
  @HiveField(20)
  final CurationInfoEntity curationInfo;
  @HiveField(21, defaultValue: false)
  final bool isNoteCollapsible;
}
