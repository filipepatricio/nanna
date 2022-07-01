import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/other_brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';
import 'package:better_informed_mobile/domain/article/exception/article_geoblocked_exception.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_header_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_other_brief_entries_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/set_reading_banner_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/track_article_reading_progress_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/get_show_article_more_from_brief_section_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/get_show_article_related_content_section_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/use_case/get_topic_by_slug_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/use_case/trade_topid_id_for_slug_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/media/article_scroll_data.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_cubit.di.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:neat_periodic_task/neat_periodic_task.dart';

@injectable
class MediaItemCubit extends Cubit<MediaItemState> {
  MediaItemCubit(
    this._setStartedArticleStreamUseCase,
    this._getArticleUseCase,
    this._trackActivityUseCase,
    this._getArticleHeaderUseCase,
    this._tradeTopicIdForSlugUseCase,
    this._trackArticleReadingProgressUseCase,
    this._getShowArticleRelatedContentSectionUseCase,
    this._getShowArticleMoreFromBriefSectionUseCase,
    this._getOtherBriefEntriesUseCase,
    this._getTopicBySlugUseCase,
  ) : super(const MediaItemState.initializing());

  final SetReadingBannerStreamUseCase _setStartedArticleStreamUseCase;
  final GetArticleUseCase _getArticleUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final GetArticleHeaderUseCase _getArticleHeaderUseCase;
  final TradeTopicIdForSlugUseCase _tradeTopicIdForSlugUseCase;
  final TrackArticleReadingProgressUseCase _trackArticleReadingProgressUseCase;
  final GetShowArticleRelatedContentSectionUseCase _getShowArticleRelatedContentSectionUseCase;
  final GetShowArticleMoreFromBriefSectionUseCase _getShowArticleMoreFromBriefSectionUseCase;
  final GetOtherBriefEntriesUseCase _getOtherBriefEntriesUseCase;
  final GetTopicBySlugUseCase _getTopicBySlugUseCase;

  late MediaItemArticle _currentArticle;
  late String? _topicId;
  late String? _briefId;
  late NeatPeriodicTaskScheduler? readingProgressTrackingScheduler;

  String? get topicId => _topicId;
  String? get briefId => _briefId;

  Article? _currentFullArticle;
  final List<OtherBriefEntryItem> _otherBrief = [];

  var scrollData = MediaItemScrollData.initial();

  var readingComplete = false;

  @override
  Future<void> close() async {
    await readingProgressTrackingScheduler?.stop();
    return super.close();
  }

  Future<void> initialize(
    MediaItemArticle? article,
    String? slug,
    String? topicId,
    String? topicSlug,
    String? briefId,
  ) async {
    if (article == null && slug == null) {
      emit(const MediaItemState.emptyError());
      Fimber.e('Article and slug were null on article page.');
      return;
    }

    _topicId = topicId;
    _briefId = briefId;

    _setupReadingProgressTracker();

    if (article != null) {
      await _initializeWithArticle(article, topicId);
    } else if (slug != null) {
      await _initializeWithSlug(slug, topicSlug);
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

  Future<void> _initializeWithSlug(String slug, String? topicSlug) async {
    emit(const MediaItemState.loading());

    try {
      final article = await _getArticleHeaderUseCase(slug);
      _currentArticle = article;

      await _trackWithTopicSlug(article.id, topicSlug);

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

  Future<void> _trackWithTopicSlug(String articleId, String? topicSlug) async {
    if (topicSlug != null) {
      final topicId = await _tradeTopicIdForSlugUseCase(topicSlug);
      _trackActivityUseCase.trackPage(AnalyticsPage.article(articleId, topicId));
    } else {
      _trackActivityUseCase.trackPage(AnalyticsPage.article(articleId));
    }
  }

  Future<void> _loadPremiumArticle(MediaItemArticle article) async {
    try {
      _currentFullArticle = await _getArticleUseCase(article);

      await _showIdlePremiumOrErrorState();
    } on ArticleGeoblockedException {
      emit(const MediaItemState.geoblocked());
    } catch (e, s) {
      Fimber.e('Fetching full article failed', ex: e, stacktrace: s);
      emit(MediaItemState.error(_currentArticle));
    }
  }

  Future<void> _loadOtherBrief(String articleSlug) async {
    final brief = await _getOtherBriefEntriesUseCase(articleSlug);

    for (final b in brief) {
      if (b is OtherBriefEntryItemArticle) {
        final article = await _getArticleHeaderUseCase(b.slug);
        _otherBrief.add(b.copyWith(article: article));
        continue;
      }

      if (b is OtherBriefEntryItemTopic) {
        final topic = await _getTopicBySlugUseCase(b.slug);
        _otherBrief.add(b.copyWith(topic: topic));
        continue;
      }
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
    _trackReadingProgress();
    _updateReadingBannerState(scrollData.progress);
  }

  void _setupReadingProgressTracker() {
    readingProgressTrackingScheduler = kIsTest
        ? null
        : NeatPeriodicTaskScheduler(
            interval: const Duration(seconds: 5),
            name: 'reading-progress-tracker',
            timeout: const Duration(seconds: 1),
            task: _trackReadingProgress,
            minCycle: const Duration(seconds: 2),
          );

    readingProgressTrackingScheduler?.start();
  }

  Future<void> _trackReadingProgress() async {
    final progress = (scrollData.progress * 100).toInt().clamp(0, 100);
    _trackArticleReadingProgressUseCase.call(_currentArticle.slug, progress);
    return;
  }

  void _resetBannerState() {
    readingComplete = false;
    final readingBanner = ReadingBanner(article: _currentArticle, scrollProgress: 0.0);
    _setStartedArticleStreamUseCase(readingBanner);
  }

  Future<void> _showIdlePremiumOrErrorState() async {
    final article = _currentFullArticle;
    if (article == null) {
      emit(MediaItemState.error(_currentArticle));
    } else {
      final showArticleRelatedContentSection = await _getShowArticleRelatedContentSectionUseCase();
      final showArticleMoreFromBriefSection = await _getShowArticleMoreFromBriefSectionUseCase();

      if (showArticleMoreFromBriefSection) {
        await _loadOtherBrief(article.metadata.slug);
      }

      emit(
        MediaItemState.idlePremium(
          article,
          _otherBrief,
          showArticleRelatedContentSection,
          showArticleMoreFromBriefSection,
        ),
      );
    }
  }

  void _updateReadingBannerState(double progress) {
    final article = _currentFullArticle;
    if (article == null) return;

    if (!readingComplete) {
      if (progress == scrollEnd) {
        readingComplete = true;
      }
      final readingBanner = ReadingBanner(article: _currentArticle, scrollProgress: progress);
      _setStartedArticleStreamUseCase.call(readingBanner);
    }
  }
}

extension on MediaItemScrollData {
  double get progress => contentHeight > 0 ? readArticleContentOffset / contentHeight : 0.0;
}
