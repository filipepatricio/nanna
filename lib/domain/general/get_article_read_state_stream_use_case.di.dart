import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/general/article_read_state_notifier.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetArticleReadStateStreamUseCase {
  GetArticleReadStateStreamUseCase(this._notifier);

  final ArticleReadStateNotifier _notifier;

  Stream<MediaItemArticle> call(String articleId) {
    return _notifier.stream.where((event) => event.id == articleId);
  }
}
