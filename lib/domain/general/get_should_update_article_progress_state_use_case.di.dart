import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/general/should_refresh_article_progress_state_notifier.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetShouldUpdateArticleProgressStateUseCase {
  GetShouldUpdateArticleProgressStateUseCase(this._notifier);

  final ShouldRefreshArticleProgressStateNotifier _notifier;

  Stream<MediaItemArticle> call() {
    return _notifier.stream;
  }
}