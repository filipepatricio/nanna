import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_full_article_use_case.dart';
import 'package:better_informed_mobile/domain/article/use_case/set_reading_banner_use_case.dart';
import 'package:better_informed_mobile/presentation/page/article/article_scroll_data.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

import 'article_state.dart';

@injectable
class ArticleCubit extends Cubit<ArticleState> {
  final SetReadingBannerStreamUseCase _setStartedArticleStreamUseCase;
  final GetFullArticleUseCase _getFullArticleUseCase;

  late ArticleHeader _header;
  Article? _fullArticle;
  ArticleScrollData scrollData = ArticleScrollData(
    contentOffset: 0,
    articlePageHeight: 0,
    articleContentHeight: 0,
    readArticleContentOffset: 0,
  );

  ArticleCubit(
    this._setStartedArticleStreamUseCase,
    this._getFullArticleUseCase,
  ) : super(const ArticleState.initializing());

  var readingComplete = false;

  Future<void> initialize(ArticleHeader header) async {
    _header = header;

    emit(ArticleState.loading(_header));
    _resetBannerState();
    try {
      _fullArticle = await _getFullArticleUseCase(_header.slug);
    } catch (e, s) {
      Fimber.e('Fetching full article failed', ex: e, stacktrace: s);
    }
    _showIdleState();
  }

  void _resetBannerState() {
    readingComplete = false;
    final readingBanner = ReadingBanner(article: _header, scrollProgress: 0.0);
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

  void setupScrollData(double globalContentOffset, double globalPageOffset) {
    scrollData = scrollData.copyWith(
      contentOffset: globalContentOffset - globalPageOffset,
    );
  }

  void updateScrollData(double scrollOffset, double maxExtent) {
    scrollData = scrollData.copyWith(
      readArticleContentOffset: scrollOffset,
      articleContentHeight: maxExtent - scrollData.contentOffset,
      articlePageHeight: maxExtent,
    );

    final progress = scrollData.readArticleContentOffset / scrollData.articleContentHeight;
    _updateReadingBannerState(progress);
  }

  void _updateReadingBannerState(double progress) {
    final article = _fullArticle;
    if (article == null) return;

    if (!readingComplete) {
      if (progress == scrollEnd) {
        readingComplete = true;
      }
      final readingBanner = ReadingBanner(article: _header, scrollProgress: progress);
      _setStartedArticleStreamUseCase.call(readingBanner);
    }
  }
}
