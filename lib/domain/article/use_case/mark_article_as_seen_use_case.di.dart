import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/update_brief_entry_new_state_notifier_use_case.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class MarkArticleAsSeenUseCase {
  MarkArticleAsSeenUseCase(
    this._articleRepository,
    this._updateBriefEntryNewStateNotifierUseCase,
  );

  final ArticleRepository _articleRepository;
  final UpdateBriefEntryNewStateNotifierUseCase _updateBriefEntryNewStateNotifierUseCase;

  Future<void> call(BriefEntry entry) async {
    final isMarkedAsSeen = await _articleRepository.markArticleAsSeen(entry.slug);
    if (isMarkedAsSeen) {
      final updatedEntry = entry.copyWith(isNew: false);
      _updateBriefEntryNewStateNotifierUseCase.call(updatedEntry);
    }
  }
}
