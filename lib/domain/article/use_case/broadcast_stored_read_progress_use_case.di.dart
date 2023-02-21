import 'package:better_informed_mobile/domain/article/article_local_repository.dart';
import 'package:better_informed_mobile/domain/article/article_progress_local_repository.dart';
import 'package:better_informed_mobile/domain/article/use_case/update_article_progress_state_notifier_use_case.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class BroadcastStoredReadProgressUseCase {
  BroadcastStoredReadProgressUseCase(
    this._articleProgressLocalRepository,
    this._articleLocalRepository,
    this._updateArticleProgressUseCase,
  );

  final ArticleProgressLocalRepository _articleProgressLocalRepository;
  final ArticleLocalRepository _articleLocalRepository;
  final UpdateArticleProgressStateNotifierUseCase _updateArticleProgressUseCase;

  Future<void> call() async {
    final storedProgressIdList = await _articleProgressLocalRepository.getAllIds();
    for (final progressId in storedProgressIdList) {
      final progress = await _articleProgressLocalRepository.load(progressId);
      if (progress == null || progress.isExpired) {
        continue;
      }

      final articleSynchronizable = await _articleLocalRepository.load(progress.dataId);
      final article = articleSynchronizable?.data;
      if (article != null) {
        _updateArticleProgressUseCase(article.metadata);
      }
    }
  }
}
