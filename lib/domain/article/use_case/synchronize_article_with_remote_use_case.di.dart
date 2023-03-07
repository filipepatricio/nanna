import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_header_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/has_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/synchronize_with_remote_use_case.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class SynchronizeArticleWithRemoteUseCase implements SynchronizeWithRemoteUsecase<Article> {
  SynchronizeArticleWithRemoteUseCase(
    this._getArticleUseCase,
    this._getArticleHeaderUseCase,
    this._hasActiveSubscriptionUseCase,
  );

  final GetArticleUseCase _getArticleUseCase;
  final GetArticleHeaderUseCase _getArticleHeaderUseCase;
  final HasActiveSubscriptionUseCase _hasActiveSubscriptionUseCase;

  @override
  Future<Synchronizable<Article>> call(Synchronizable<Article> synchronizable) async {
    if (!await _hasActiveSubscriptionUseCase()) return synchronizable;

    final header = await _getArticleHeaderUseCase(synchronizable.dataId);
    final article = await _getArticleUseCase.single(header);

    return synchronizable.synchronize(article);
  }
}
