import 'dart:async';

import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_use_case.dart';
import 'package:better_informed_mobile/domain/article/use_case/set_reading_banner_use_case.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/presentation/page/article/article_scroll_data.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import 'article_state.dart';

@injectable
class ArticleCubit extends Cubit<ArticleState> {
  final SetReadingBannerStreamUseCase _setStartedArticleStreamUseCase;
  final GetArticleUseCase _getArticleUseCase;

  late List<Entry> _allEntries;
  late int _index;

  Article? _currentFullArticle;

  ArticleScrollData scrollData = ArticleScrollData.initial();

  ArticleCubit(
    this._setStartedArticleStreamUseCase,
    this._getArticleUseCase,
  ) : super(const ArticleState.initializing());

  var readingComplete = false;

  Future<void> initialize(List<Entry> entries, int index) async {
    _allEntries = entries;
    _index = index;

    final currentEntry = _allEntries[_index];

    emit(const ArticleState.loading());
    _resetBannerState();

    try {
      _currentFullArticle = await _getArticleUseCase(currentEntry);
      _showIdleOrErrorState();
    } catch (e, s) {
      Fimber.e('Fetching full article failed', ex: e, stacktrace: s);
      emit(ArticleState.error(_getCurrentHeader()));
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

  Future<void> loadNextArticle(Completer completer) async {
    final nextIndex = _index + 1;
    if (nextIndex < _allEntries.length) {
      final nextArticleHeader = _allEntries[nextIndex];

      try {
        final articleFuture = _getArticleUseCase(nextArticleHeader);
        final delay = Future.delayed(const Duration(seconds: 2));
        final nextArticle = await Rx.zip2<Article, dynamic, Article>(
          articleFuture.asStream(),
          delay.asStream(),
          (a, b) => a,
        ).last;

        _currentFullArticle = nextArticle;
        _index = nextIndex;

        scrollData = ArticleScrollData.initial();
        _resetBannerState();

        _showIdleOrErrorState();
        emit(ArticleState.nextPageLoaded(_index));
      } catch (e, s) {
        Fimber.e('Fetching next full article failed', ex: e, stacktrace: s);
        emit(ArticleState.error(_getCurrentHeader()));
      }
    }

    completer.complete();
  }

  void _resetBannerState() {
    readingComplete = false;
    final readingBanner = ReadingBanner(entry: _getCurrentHeader(), scrollProgress: 0.0);
    _setStartedArticleStreamUseCase(readingBanner);
  }

  void _showIdleOrErrorState() {
    final article = _currentFullArticle;
    if (article == null) {
      emit(ArticleState.error(_getCurrentHeader()));
    } else {
      if (_allEntries.length > 1) {
        final hasNextArticle = _index < _allEntries.length - 1;
        emit(ArticleState.idleMultiArticles(article.entry, article.content, hasNextArticle));
      } else {
        emit(ArticleState.idleSingleArticle(article.entry, article.content));
      }
    }
  }

  void _updateReadingBannerState(double progress) {
    final article = _currentFullArticle;
    if (article == null) return;

    if (!readingComplete) {
      if (progress == scrollEnd) {
        readingComplete = true;
      }
      final readingBanner = ReadingBanner(entry: _getCurrentHeader(), scrollProgress: progress);
      _setStartedArticleStreamUseCase.call(readingBanner);
    }
  }

  Entry _getCurrentHeader() => _allEntries[_index];
}
