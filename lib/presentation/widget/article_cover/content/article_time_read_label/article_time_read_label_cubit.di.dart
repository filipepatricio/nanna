import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/general/get_should_update_article_progress_state_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/content/article_time_read_label/article_time_read_label_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleTimeReadLabelCubit extends Cubit<ArticleTimeReadLabelState> {
  ArticleTimeReadLabelCubit(
    this._getShouldUpdateArticleProgressStateUseCase,
  ) : super(ArticleTimeReadLabelState.initializing());

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
    emit(ArticleTimeReadLabelState.idle(_article.progressState, _article.timeToRead));
    _shouldUpdateArticleProgressStateSubscription =
        _getShouldUpdateArticleProgressStateUseCase().listen((updatedArticle) {
      if (_article.id == updatedArticle.id) {
        _article.copyWith(progressState: updatedArticle.progressState);
        emit(ArticleTimeReadLabelState.idle(_article.progressState, _article.timeToRead));
      }
    });
  }
}
