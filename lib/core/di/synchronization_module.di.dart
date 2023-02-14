import 'package:better_informed_mobile/domain/article/article_local_repository.dart';
import 'package:better_informed_mobile/domain/article/article_progress_local_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:better_informed_mobile/domain/article/use_case/synchroniza_article_progress_with_remote_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/synchronize_article_with_remote_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable_group.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/topics_local_repository.dart';
import 'package:better_informed_mobile/domain/topic/use_case/synchronize_topic_with_remote_use_case.di.dart';
import 'package:injectable/injectable.dart';

@module
abstract class SynchronizationModule {
  @injectable
  List<SynchronizableGroup> getSynchronizeGroups(
    BookmarkLocalRepository bookmarkLocalRepository,
    TopicsLocalRepository topicsLocalRepository,
    ArticleLocalRepository articleLocalRepository,
    ArticleProgressLocalRepository articleProgressLocalRepository,
    SynchronizeTopicWithRemoteUseCase synchronizeTopicWithRemoteUseCase,
    SynchronizeArticleWithRemoteUseCase synchronizeArticleWithRemoteUseCase,
    SynchronizaArticleProgressWithRemoteUseCase synchronizaArticleProgressWithRemoteUseCase,
  ) {
    return [
      SynchronizableGroup<Bookmark>(
        bookmarkLocalRepository,
        null,
      ),
      SynchronizableGroup<Topic>(
        topicsLocalRepository,
        synchronizeTopicWithRemoteUseCase,
      ),
      SynchronizableGroup<Article>(
        articleLocalRepository,
        synchronizeArticleWithRemoteUseCase,
      ),
      SynchronizableGroup<ArticleProgress>(
        articleProgressLocalRepository,
        synchronizaArticleProgressWithRemoteUseCase,
      ),
    ];
  }
}
