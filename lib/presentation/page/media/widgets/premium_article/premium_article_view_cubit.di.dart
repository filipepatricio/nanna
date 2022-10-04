import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_free_articles_left_warning_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_other_brief_entries_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_other_topic_entries_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_related_content_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/track_article_reading_progress_use_case.di.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dt.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:better_informed_mobile/domain/categories/use_case/get_featured_categories_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/use_case/get_topic_by_slug_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/media/article_scroll_data.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:neat_periodic_task/neat_periodic_task.dart';

@injectable
class PremiumArticleViewCubit extends Cubit<PremiumArticleViewState> {
  PremiumArticleViewCubit(
    this._trackActivityUseCase,
    this._getTopicBySlugUseCase,
    this._trackArticleReadingProgressUseCase,
    this._getOtherBriefEntriesUseCase,
    this._getOtherTopicEntriesUseCase,
    this._getFeaturedCategoriesUseCase,
    this._getRelatedContentUseCase,
    this._getArticleUseCase,
    this._getFreeArticlesLeftWarningStreamUseCase,
    this._getActiveSubscriptionUseCase,
  ) : super(const PremiumArticleViewState.initial());

  final TrackActivityUseCase _trackActivityUseCase;
  final GetTopicBySlugUseCase _getTopicBySlugUseCase;
  final TrackArticleReadingProgressUseCase _trackArticleReadingProgressUseCase;
  final GetOtherBriefEntriesUseCase _getOtherBriefEntriesUseCase;
  final GetOtherTopicEntriesUseCase _getOtherTopicEntriesUseCase;
  final GetFeaturedCategoriesUseCase _getFeaturedCategoriesUseCase;
  final GetRelatedContentUseCase _getRelatedContentUseCase;
  final GetArticleUseCase _getArticleUseCase;
  final GetFreeArticlesLeftWarningStreamUseCase _getFreeArticlesLeftWarningStreamUseCase;
  final GetActiveSubscriptionUseCase _getActiveSubscriptionUseCase;

  final moreFromBriefItems = <BriefEntryItem>[];
  final otherTopicItems = <MediaItem>[];
  final relatedContentItems = <CategoryItem>[];
  final featuredCategories = <Category>[];

  StreamSubscription? _activeSubscriptionStreamSubscription;
  StreamSubscription? _freeArticlesLeftWarningSubscription;
  String? _lastFreeArticlesLeftWarning;

  late Article _currentFullArticle;
  late String? _topicId;
  late String? _briefId;
  late String? _topicTitle;
  late NeatPeriodicTaskScheduler? _readingProgressTrackingScheduler;

  ArticleProgress? _articleProgress;

  ArticleProgress? get articleProgress => _articleProgress;
  String? get topicId => _topicId;
  String? get briefId => _briefId;
  String get topicTitle {
    if (_topicTitle != null) {
      return _topicTitle!;
    }
    Fimber.e('_topicTitle was requested and is null');
    return '';
  }

  Article get article => _currentFullArticle;

  var scrollData = MediaItemScrollData.initial();

  @override
  Future<void> close() async {
    await _readingProgressTrackingScheduler?.stop();
    await _freeArticlesLeftWarningSubscription?.cancel();
    await _activeSubscriptionStreamSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize(
    Article article,
    String? briefId,
    String? topicSlug,
    String? topicId,
  ) async {
    emit(const PremiumArticleViewState.initial());

    _briefId = briefId;
    _topicId = topicId;

    _currentFullArticle = article;

    emit(
      PremiumArticleViewState.idle(
        article: _currentFullArticle,
        moreFromBriefItems: moreFromBriefItems,
        otherTopicItems: otherTopicItems,
        featuredCategories: featuredCategories,
        relatedContentItems: relatedContentItems,
        enablePageSwipe: true,
      ),
    );

    _setupReadingProgressTracker();

    if (topicSlug != null) {
      _topicTitle = (await _getTopicBySlugUseCase.call(topicSlug)).strippedTitle;
      otherTopicItems.addAll(await _getOtherTopicEntriesUseCase(_currentFullArticle.metadata.slug, topicSlug));
    } else if (briefId != null) {
      moreFromBriefItems.addAll(await _getOtherBriefEntriesUseCase(_currentFullArticle.metadata.slug, briefId));
    }

    featuredCategories.addAll(await _getFeaturedCategoriesUseCase());
    relatedContentItems.addAll(await _getRelatedContentUseCase(_currentFullArticle.metadata.slug));

    emit(
      PremiumArticleViewState.idle(
        article: _currentFullArticle,
        moreFromBriefItems: moreFromBriefItems,
        otherTopicItems: otherTopicItems,
        featuredCategories: featuredCategories,
        relatedContentItems: relatedContentItems,
        enablePageSwipe: true,
      ),
    );

    _freeArticlesLeftWarningSubscription = _getFreeArticlesLeftWarningStreamUseCase().listen(
      (warning) {
        if (_lastFreeArticlesLeftWarning != warning) {
          _lastFreeArticlesLeftWarning = warning;

          final lastState = state;
          emit(PremiumArticleViewState.freeArticlesWarning(message: warning));
          emit(lastState);
        }
      },
    );

    _activeSubscriptionStreamSubscription = _getActiveSubscriptionUseCase.stream.listen((_) => refreshArticle());
  }

  Future<void> refreshArticle() async {
    emit(const PremiumArticleViewState.initial());

    _currentFullArticle = await _getArticleUseCase(article.metadata);

    emit(
      PremiumArticleViewState.idle(
        article: _currentFullArticle,
        moreFromBriefItems: moreFromBriefItems,
        otherTopicItems: otherTopicItems,
        featuredCategories: featuredCategories,
        relatedContentItems: relatedContentItems,
        enablePageSwipe: true,
      ),
    );
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
  }

  void _setupReadingProgressTracker() {
    _readingProgressTrackingScheduler = kIsTest
        ? null
        : NeatPeriodicTaskScheduler(
            interval: const Duration(seconds: 3),
            name: 'reading-progress-tracker-premium',
            timeout: const Duration(milliseconds: 1500),
            task: _scheduledTrackReadingProgress,
            minCycle: const Duration(milliseconds: 1500),
          );

    _readingProgressTrackingScheduler?.start();
  }

  Future<void> _scheduledTrackReadingProgress() async {
    if (scrollData.progress > 0) {
      await trackReadingProgress();
    }
    return;
  }

  Future<void> trackReadingProgress() async {
    if (_currentFullArticle.metadata.availableInSubscription) {
      final progress = (scrollData.progress * 100).toInt().clamp(1, 100);
      _articleProgress = await _trackArticleReadingProgressUseCase.call(_currentFullArticle.metadata.slug, progress);
    }
    return;
  }

  void onRelatedContentItemTap(CategoryItem item) {
    _trackActivityUseCase
        .trackEvent(AnalyticsEvent.articleRelatedContentItemTapped(_currentFullArticle.metadata.id, item));
  }

  void onRelatedCategoryTap(Category category) {
    _trackActivityUseCase
        .trackEvent(AnalyticsEvent.articleRelatedCategoryTapped(_currentFullArticle.metadata.id, category.name));
  }

  void onMoreFromBriefItemTap(BriefEntryItem item) {
    _trackActivityUseCase
        .trackEvent(AnalyticsEvent.articleMoreFromBriefItemTapped(_currentFullArticle.metadata.id, item));
  }

  void onOtherTopicItemTap(MediaItem item) {
    _trackActivityUseCase
        .trackEvent(AnalyticsEvent.articleMoreFromTopicItemTapped(_currentFullArticle.metadata.id, item));
  }

  void enablePageSwipe(bool enable) {
    emit(
      PremiumArticleViewState.idle(
        article: _currentFullArticle,
        moreFromBriefItems: moreFromBriefItems,
        otherTopicItems: otherTopicItems,
        featuredCategories: featuredCategories,
        relatedContentItems: relatedContentItems,
        enablePageSwipe: enable,
      ),
    );
  }
}

extension on MediaItemScrollData {
  double get progress => contentHeight > 0 ? readArticleContentOffset / contentHeight : 0.0;
}

extension ScrollPhysicExtension on PremiumArticleViewState {
  ScrollPhysics get scrollPhysics => kIsAppleDevice
      ? const ClampingScrollPhysics()
      : maybeMap(
          orElse: () => const ClampingScrollPhysics(),
          idle: (e) => e.enablePageSwipe ? const ClampingScrollPhysics() : const NeverScrollableScrollPhysics(),
        );
}
