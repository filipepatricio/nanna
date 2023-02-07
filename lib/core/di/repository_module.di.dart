import 'package:better_informed_mobile/data/bookmark/database/bookmark_hive_local_repository.di.dart';
import 'package:better_informed_mobile/data/bookmark/database/mapper/bookmark_sort_config_name_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/bookmark/database/mapper/synchronizable_bookmark_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/subscription/database/mapper/active_subscription_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/subscription/database/subscription_hive_local_repository.di.dart';
import 'package:better_informed_mobile/data/user/database/mapper/user_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/user/database/user_hive_local_repository.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/subscription/subscription_local_repository.dart';
import 'package:better_informed_mobile/domain/user/user_local_repository.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RepositoryModule {
  // @dev
  // @test
  // @prod
  // @Environment(integrationProdTestName)
  // @Environment(integrationStageTestName)
  // @preResolve
  // Future<ArticleLocalRepository> getArticleLocalRepository(SynchronizableArticleEntityMapper articleEntityMapper) {
  //   return ArticleHiveLocalRepository.create(articleEntityMapper);
  // }

  // @dev
  // @test
  // @prod
  // @Environment(integrationProdTestName)
  // @Environment(integrationStageTestName)
  // @preResolve
  // Future<TopicsLocalRepository> getTopicsLocalRepository(SynchronizableTopicEntityMapper topicEntityMapper) {
  //   return TopicsHiveLocalRepository.create(topicEntityMapper);
  // }

  @dev
  @test
  @prod
  @Environment(integrationProdTestName)
  @Environment(integrationStageTestName)
  @preResolve
  Future<SubscriptionLocalRepository> getSubscriptionLocalRepository(
    ActiveSubscriptionEntityMapper activeSubscriptionEntityMapper,
  ) async {
    return SubscriptionHiveLocalRepository.create(activeSubscriptionEntityMapper);
  }

  @dev
  @test
  @prod
  @Environment(integrationProdTestName)
  @Environment(integrationStageTestName)
  @preResolve
  Future<UserLocalRepository> getUserLocalRepository(UserEntityMapper userEntityMapper) {
    return UserHiveLocalRepository.create(userEntityMapper);
  }

  @dev
  @test
  @prod
  @Environment(integrationProdTestName)
  @Environment(integrationStageTestName)
  @preResolve
  Future<BookmarkLocalRepository> getBookmarkLocalRepository(
    BookmarkSortConfigNameEntityMapper bookmarkSortConfigNameEntityMapper,
    SynchronizableBookmarkEntityMapper synchronizableBookmarkEntityMapper,
  ) {
    return BookmarkHiveLocalRepository.create(
      bookmarkSortConfigNameEntityMapper,
      synchronizableBookmarkEntityMapper,
    );
  }
}