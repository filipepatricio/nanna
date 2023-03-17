import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_seen.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/brief_entry_new_state_notifier.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/decrease_brief_unseen_count_state_notifier_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/save_seen_entry_locally_use_case.di.dart';
import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:better_informed_mobile/domain/topic/topics_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class MarkEntryAsSeenUseCase {
  MarkEntryAsSeenUseCase(
    this._topicsRepository,
    this._articleRepository,
    this._saveSeenItemLocallyUseCase,
    this._briefEntryNewStateNotifier,
    this._decreaseBriefUnseenCountStateNotifierUseCase,
  );

  final TopicsRepository _topicsRepository;
  final ArticleRepository _articleRepository;
  final SaveSeenEntryLocallyUseCase _saveSeenItemLocallyUseCase;
  final BriefEntryNewStateNotifier _briefEntryNewStateNotifier;
  final DecreaseBriefUnseenCountStateNotifierUseCase _decreaseBriefUnseenCountStateNotifierUseCase;

  Future<void> call(BriefEntry entry) async {
    bool isMarkedAsSeen = false;

    try {
      isMarkedAsSeen = await entry.item.map(
        article: (article) => _articleRepository.markArticleAsSeen(entry.slug),
        topicPreview: (topic) => _topicsRepository.markTopicAsSeen(entry.slug),
        unknown: (_) => throw Exception('Unknown item type'),
      );
    } on NoInternetConnectionException {
      await _saveSeenItemLocallyUseCase(entry);
      isMarkedAsSeen = true;
    }

    if (isMarkedAsSeen) {
      _briefEntryNewStateNotifier.notify(BriefEntrySeen.fromEntry(entry));
      _decreaseBriefUnseenCountStateNotifierUseCase(entry.slug);
    }
  }
}
