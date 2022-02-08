import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/analytics_page.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_header_use_case.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_use_case.dart';
import 'package:better_informed_mobile/domain/article/use_case/set_reading_banner_use_case.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/media/article_scroll_data.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

import 'media_item_state.dart';

@injectable
class MediaItemCubit extends Cubit<MediaItemState> {
  final SetReadingBannerStreamUseCase _setStartedArticleStreamUseCase;
  final GetArticleUseCase _getArticleUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final GetArticleHeaderUseCase _getArticleHeaderUseCase;

  late MediaItemArticle _currentArticle;
  Article? _currentFullArticle;

  MediaItemScrollData scrollData = MediaItemScrollData.initial();

  MediaItemCubit(
    this._setStartedArticleStreamUseCase,
    this._getArticleUseCase,
    this._trackActivityUseCase,
    this._getArticleHeaderUseCase,
  ) : super(const MediaItemState.initializing());

  var readingComplete = false;

  Future<void> initialize(MediaItemArticle? article, String? slug, String? topicId) async {
    if (article == null && slug == null) {
      emit(const MediaItemState.emptyError());
      Fimber.e('Article and slug were null on article page.');
      return;
    }

    if (article != null) {
      await _initializeWithArticle(article, topicId);
    } else if (slug != null) {
      await _initializeWithSlug(slug, topicId);
    }
  }

  Future<void> _initializeWithArticle(MediaItemArticle article, String? topicId) async {
    _currentArticle = article;
    _trackActivityUseCase.trackPage(AnalyticsPage.article(article.id, topicId));

    emit(const MediaItemState.loading());

    _resetBannerState();

    if (article.type == ArticleType.free) {
      emit(MediaItemState.idleFree(article));
      return;
    }

    await _loadPremiumArticle(article);
  }

  Future<void> _initializeWithSlug(String slug, String? topicId) async {
    emit(const MediaItemState.loading());

    try {
      final article = await _getArticleHeaderUseCase(slug);
      _currentArticle = article;
      _trackActivityUseCase.trackPage(AnalyticsPage.article(article.id, topicId));

      if (article.type == ArticleType.free) {
        emit(MediaItemState.idleFree(article));
        return;
      }

      await _loadPremiumArticle(article);
    } catch (e, s) {
      Fimber.e('Fetching article header failed', ex: e, stacktrace: s);
      emit(const MediaItemState.emptyError());
    }
  }

  Future<void> _loadPremiumArticle(MediaItemArticle article) async {
    try {
      _currentFullArticle = await _getArticleUseCase(article);
      _showIdlePremiumOrErrorState();
    } catch (e, s) {
      Fimber.e('Fetching full article failed', ex: e, stacktrace: s);
      emit(MediaItemState.error(_currentArticle));
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

  void _resetBannerState() {
    readingComplete = false;
    final readingBanner = ReadingBanner(article: _getCurrentHeader(), scrollProgress: 0.0);
    _setStartedArticleStreamUseCase(readingBanner);
  }

  void _showIdlePremiumOrErrorState() {
    final article = _currentFullArticle;
    if (article == null) {
      emit(MediaItemState.error(_getCurrentHeader()));
    } else {
      emit(MediaItemState.idlePremium(article.article, article.content));
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

  MediaItemArticle _getCurrentHeader() => _currentArticle;
}
