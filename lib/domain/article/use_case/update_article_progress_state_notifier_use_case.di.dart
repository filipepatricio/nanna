import 'package:better_informed_mobile/domain/article/use_case/article_read_state_notifier.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateArticleProgressStateNotifierUseCase {
  const UpdateArticleProgressStateNotifierUseCase(this._notifier);

  final ArticleReadStateNotifier _notifier;

  void call(MediaItemArticle article) => _notifier.notify(article);
}
