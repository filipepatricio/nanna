import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_full_article_use_case.dart';
import 'package:better_informed_mobile/domain/article/use_case/set_reading_banner_use_case.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import 'article_state.dart';

@injectable
class ArticleCubit extends Cubit<ArticleState> {
  final SetReadingBannerStreamUseCase _setStartedArticleStreamUseCase;
  final GetFullArticleUseCase _getFullArticleUseCase;

  late ArticleHeader _header;
  Article? _fullArticle;

  ArticleCubit(
    this._setStartedArticleStreamUseCase,
    this._getFullArticleUseCase,
  ) : super(const ArticleState.initializing());

  var readingComplete = false;

  Future<void> initialize(ArticleHeader header) async {
    _header = header;

    emit(ArticleState.loading(_header));
    _resetBannerState();

    _fullArticle = await _getFullArticleUseCase(_header.slug);
    _showIdleState();
  }

  void updateReadingBannerState(double progress, double scrollOffset) {
    final article = _fullArticle;
    if (article == null) return;

    if (!readingComplete) {
      if (progress == scrollEnd) {
        readingComplete = true;
      }
      final readingBanner = ReadingBanner(article: _header, scrollProgress: progress, scrollOffset: scrollOffset);
      _setStartedArticleStreamUseCase.call(readingBanner);
    }
  }

  void _resetBannerState() {
    readingComplete = false;
    final readingBanner = ReadingBanner(article: _header, scrollProgress: 0.0, scrollOffset: 0.0);
    _setStartedArticleStreamUseCase.call(readingBanner);
  }

  void _showIdleState() {
    final article = _fullArticle;
    if (article == null) {
      emit(ArticleState.loading(_header));
    } else {
      emit(ArticleState.idle(article.header, article.content));
    }
  }
}
