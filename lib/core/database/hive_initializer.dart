import 'package:better_informed_mobile/data/article/database/entity/article_audio_file_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/article_content_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/article_content_type_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/article_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/article_header_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/article_image_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/article_kind_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/article_progress_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/article_progress_state_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/article_type_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/category_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/curation_info_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/curator_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/image_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/publisher_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/entity/synchronizable_article_entity.hv.dart';
import 'package:better_informed_mobile/data/bookmark/database/entity/bookmark_data_entity.hv.dart';
import 'package:better_informed_mobile/data/bookmark/database/entity/bookmark_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/entity/entry_style_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/entity/entry_style_type_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/entity/media_item_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/entity/synchronizable_topic_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/entity/topic_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/entity/topic_entry_entity.hv.dart';
import 'package:better_informed_mobile/data/topic/database/entity/topic_publisher_information_entity.hv.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initializeHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ArticleHeaderEntityAdapter());
  Hive.registerAdapter(ArticleImageEntityAdapter());
  Hive.registerAdapter(ArticleKindEntityAdapter());
  Hive.registerAdapter(ArticleProgressEntityAdapter());
  Hive.registerAdapter(ArticleProgressStateEntityAdapter());
  Hive.registerAdapter(ArticleTypeEntityAdapter());
  Hive.registerAdapter(CategoryEntityAdapter());
  Hive.registerAdapter(CurationInfoEntityAdapter());
  Hive.registerAdapter(PublisherEntityAdapter());
  Hive.registerAdapter(CuratorEntityAdapter());
  Hive.registerAdapter(CuratorExpertEntityAdapter());
  Hive.registerAdapter(CuratorEditorEntityAdapter());
  Hive.registerAdapter(CuratorEditorialTeamEntityAdapter());
  Hive.registerAdapter(CuratorUnknownEntityAdapter());
  Hive.registerAdapter(ImageEntityAdapter());
  Hive.registerAdapter(ArticleCloudinaryImageEntityAdapter());
  Hive.registerAdapter(ArticleRemoteImageEntityAdapter());
  Hive.registerAdapter(ArticleUnknownImageEntityAdapter());
  Hive.registerAdapter(ArticleContentEntityAdapter());
  Hive.registerAdapter(ArticleContentTypeEntityAdapter());
  Hive.registerAdapter(ArticleEntityAdapter());
  Hive.registerAdapter(ArticleAudioFileEntityAdapter());
  Hive.registerAdapter(BookmarkEntityAdapter());
  Hive.registerAdapter(BookmarkDataEntityAdapter());
  Hive.registerAdapter(EntryStyleEntityAdapter());
  Hive.registerAdapter(EntryStyleTypeEntityAdapter());
  Hive.registerAdapter(MediaItemEntityAdapter());
  Hive.registerAdapter(TopicEntityAdapter());
  Hive.registerAdapter(TopicEntryEntityAdapter());
  Hive.registerAdapter(TopicPublisherInformationEntityAdapter());
  Hive.registerAdapter(SynchronizableArticleEntityAdapter());
  Hive.registerAdapter(SynchronizableTopicEntityAdapter());
}
