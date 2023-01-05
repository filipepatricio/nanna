import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/general/get_should_update_article_progress_state_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleCoverCubit extends Cubit<ArticleCoverState> {
  ArticleCoverCubit(
    this._getShouldUpdateArticleProgressStateUseCase,
  ) : super(ArticleCoverState.initializing());

  final GetShouldUpdateArticleProgressStateUseCase _getShouldUpdateArticleProgressStateUseCase;

  late MediaItemArticle _article;

  StreamSubscription? _shouldUpdateArticleProgressStateSubscription;

  @override
  Future<void> close() {
    _shouldUpdateArticleProgressStateSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize(MediaItemArticle article) async {
    _article = article;
    emit(ArticleCoverState.idle(_article));
    _shouldUpdateArticleProgressStateSubscription =
        _getShouldUpdateArticleProgressStateUseCase().listen((updatedArticle) {
      if (_article.id == updatedArticle.id) {
        _article = updatedArticle;
        emit(ArticleCoverState.idle(_article));
      }
    });
  }
}
