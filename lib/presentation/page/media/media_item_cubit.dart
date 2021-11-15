import 'dart:async';

import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_use_case.dart';
import 'package:better_informed_mobile/domain/article/use_case/set_reading_banner_use_case.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/media/article_scroll_data.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import 'media_item_state.dart';

@injectable
class MediaItemCubit extends Cubit<MediaItemState> {
  final SetReadingBannerStreamUseCase _setStartedArticleStreamUseCase;
  final GetArticleUseCase _getArticleUseCase;

  late List<MediaItemArticle> _allArticles;
  late int _index;

  Article? _currentFullArticle;

  MediaItemScrollData scrollData = MediaItemScrollData.initial();

  MediaItemCubit(
    this._setStartedArticleStreamUseCase,
    this._getArticleUseCase,
  ) : super(const MediaItemState.initializing());

  var readingComplete = false;

  Future<void> initialize(List<MediaItemArticle> articles, int index) async {
    _allArticles = articles;
    _index = index;

    final currentEntry = _allArticles[_index];

    emit(const MediaItemState.loading());
    _resetBannerState();

    try {
      _currentFullArticle = await _getArticleUseCase(currentEntry);
      _showIdleOrErrorState();
    } catch (e, s) {
      Fimber.e('Fetching full article failed', ex: e, stacktrace: s);
      emit(MediaItemState.error(_getCurrentHeader()));
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
      contentHeight: maxExtent - scrollData.contentOffset,
      pageHeight: maxExtent,
    );

    final progress = scrollData.readArticleContentOffset / scrollData.contentHeight;
    _updateReadingBannerState(progress);
  }

  Future<void> loadNextArticle(Completer completer) async {
    final nextIndex = _index + 1;
    if (nextIndex < _allArticles.length) {
      final nextArticleHeader = _allArticles[nextIndex];

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

        scrollData = MediaItemScrollData.initial();
        _resetBannerState();

        _showIdleOrErrorState();
        emit(MediaItemState.nextPageLoaded(_index));
      } catch (e, s) {
        Fimber.e('Fetching next full article failed', ex: e, stacktrace: s);
        emit(MediaItemState.error(_getCurrentHeader()));
      }
    }

    completer.complete();
  }

  void _resetBannerState() {
    readingComplete = false;
    final readingBanner = ReadingBanner(article: _getCurrentHeader(), scrollProgress: 0.0);
    _setStartedArticleStreamUseCase(readingBanner);
  }

  void _showIdleOrErrorState() {
    final article = _currentFullArticle;
    if (article == null) {
      emit(MediaItemState.error(_getCurrentHeader()));
    } else {
      if (_allArticles.length > 1) {
        final hasNextArticle = _index < _allArticles.length - 1;
        emit(MediaItemState.idleMultiItems(article.article, article.content, hasNextArticle));
      } else {
        emit(MediaItemState.idleSingleItem(article.article, article.content));
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
      final readingBanner = ReadingBanner(article: _getCurrentHeader(), scrollProgress: progress);
      _setStartedArticleStreamUseCase.call(readingBanner);
    }
  }

  MediaItemArticle _getCurrentHeader() => _allArticles[_index];
}
