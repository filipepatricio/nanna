import 'package:better_informed_mobile/data/article/database/article_hive_local_repository.di.dart';
import 'package:better_informed_mobile/data/article/database/mapper/synchronizable_article_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/bookmark/database/bookmark_hive_local_repository.di.dart';
import 'package:better_informed_mobile/data/bookmark/database/mapper/bookmark_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/bookmark/database/mapper/bookmark_sort_config_name_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/database/mapper/synchronziable_topic_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/database/topics_hive_local_repository.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/article/article_local_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/topic/topics_local_repository.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RepositoryModule {
  @dev
  @test
  @prod
  @Environment(integrationProdTestName)
  @Environment(integrationStageTestName)
  @preResolve
  Future<ArticleLocalRepository> getArticleLocalRepository(SynchronizableArticleEntityMapper articleEntityMapper) {
    return ArticleHiveLocalRepository.create(articleEntityMapper);
  }

  @dev
  @test
  @prod
  @Environment(integrationProdTestName)
  @Environment(integrationStageTestName)
  @preResolve
  Future<TopicsLocalRepository> getTopicsLocalRepository(SynchronizableTopicEntityMapper topicEntityMapper) {
    return TopicsHiveLocalRepository.create(topicEntityMapper);
  }

  @dev
  @test
  @prod
  @Environment(integrationProdTestName)
  @Environment(integrationStageTestName)
  @preResolve
  Future<BookmarkLocalRepository> getBookmarkLocalRepository(
    BookmarkSortConfigNameEntityMapper bookmarkSortConfigNameEntityMapper,
    BookmarkEntityMapper bookmarkEntityMapper,
  ) {
    return BookmarkHiveLocalRepository.create(bookmarkSortConfigNameEntityMapper, bookmarkEntityMapper);
  }
}
