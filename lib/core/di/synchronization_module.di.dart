import 'package:better_informed_mobile/domain/article/article_local_repository.dart';
import 'package:better_informed_mobile/domain/article/article_progress_local_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:better_informed_mobile/domain/article/use_case/synchroniza_article_progress_with_remote_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/synchronize_article_with_remote_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/daily_brief/daily_brief_entry_seen_local_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/daily_brief_local_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_seen.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/synchronize_brief_entry_seen_with_remote_use_case.di.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable_group.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/topics_local_repository.dart';
import 'package:better_informed_mobile/domain/topic/use_case/synchronize_topic_with_remote_use_case.di.dart';
import 'package:injectable/injectable.dart';

@module
abstract class SynchronizationModule {
  @injectable
  List<SynchronizableGroup> getSynchronizeGroups(
    DailyBriefLocalRepository dailyBriefLocalRepository,
    BookmarkLocalRepository bookmarkLocalRepository,
    TopicsLocalRepository topicsLocalRepository,
    ArticleLocalRepository articleLocalRepository,
    ArticleProgressLocalRepository articleProgressLocalRepository,
    DailyBriefEntrySeenLocalRepository dailyBriefEntrySeenLocalRepository,
    SynchronizeTopicWithRemoteUseCase synchronizeTopicWithRemoteUseCase,
    SynchronizeArticleWithRemoteUseCase synchronizeArticleWithRemoteUseCase,
    SynchronizaArticleProgressWithRemoteUseCase synchronizaArticleProgressWithRemoteUseCase,
    SynchronizeBriefEntrySeenWithRemoteUseCase synchronizeBriefEntrySeenWithRemoteUseCase,
  ) {
    return [
      SynchronizableGroup<Brief>(
        dailyBriefLocalRepository,
        null,
      ),
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
      SynchronizableGroup<BriefEntrySeen>(
        dailyBriefEntrySeenLocalRepository,
        synchronizeBriefEntrySeenWithRemoteUseCase,
      ),
      SynchronizableGroup<ArticleProgress>(
        articleProgressLocalRepository,
        synchronizaArticleProgressWithRemoteUseCase,
      ),
    ];
  }
}
