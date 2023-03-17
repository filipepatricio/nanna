import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_seen.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/brief_entry_new_state_notifier.di.dart';
import 'package:better_informed_mobile/domain/synchronization/exception/synchronizable_invalidated_exception.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/synchronize_with_remote_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/topics_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SynchronizeBriefEntrySeenWithRemoteUseCase extends SynchronizeWithRemoteUsecase<BriefEntrySeen> {
  SynchronizeBriefEntrySeenWithRemoteUseCase(
    this._articleRepository,
    this._topicsRepository,
    this._briefEntryNewStateNotifier,
  );

  final ArticleRepository _articleRepository;
  final TopicsRepository _topicsRepository;
  final BriefEntryNewStateNotifier _briefEntryNewStateNotifier;

  @override
  Future<Synchronizable<BriefEntrySeen>> call(Synchronizable<BriefEntrySeen> synchronizable) async {
    final seenItem = synchronizable.data;

    if (seenItem == null) throw SynchronizableInvalidatedException();

    await seenItem.map(
      article: (article) => _articleRepository.markArticleAsSeen(article.slug),
      topic: (topic) => _topicsRepository.markTopicAsSeen(topic.slug),
    );
    _briefEntryNewStateNotifier.notify(seenItem);

    throw SynchronizableInvalidatedException();
  }
}
