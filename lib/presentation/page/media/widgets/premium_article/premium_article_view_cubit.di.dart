import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/appearance/use_case/get_preferred_text_scale_factor_use_case.di.dart';
import 'package:better_informed_mobile/domain/appearance/use_case/set_preferred_text_scale_factor_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/data/update_article_progress_response.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_free_articles_left_warning_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_other_brief_entries_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_other_topic_entries_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_related_content_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/track_article_reading_progress_use_case.di.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:better_informed_mobile/domain/categories/use_case/get_featured_categories_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/should_use_text_size_selector_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/precache_subscription_plans_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/use_case/get_topic_by_slug_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/media/article_scroll_data.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
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
    this._getFreeArticlesLeftWarningStreamUseCase,
    this._precacheSubscriptionPlansUseCase,
    this._getPreferredArticleTextScaleFactorUseCase,
    this._setPreferredArticleTextScaleFactorUseCase,
    this._shouldUseTextSizeSelectorUseCase,
  ) : super(const PremiumArticleViewState.initial());

  final TrackActivityUseCase _trackActivityUseCase;
  final GetTopicBySlugUseCase _getTopicBySlugUseCase;
  final TrackArticleReadingProgressUseCase _trackArticleReadingProgressUseCase;
  final GetOtherBriefEntriesUseCase _getOtherBriefEntriesUseCase;
  final GetOtherTopicEntriesUseCase _getOtherTopicEntriesUseCase;
  final GetFeaturedCategoriesUseCase _getFeaturedCategoriesUseCase;
  final GetRelatedContentUseCase _getRelatedContentUseCase;
  final GetFreeArticlesLeftWarningStreamUseCase _getFreeArticlesLeftWarningStreamUseCase;
  final PrecacheSubscriptionPlansUseCase _precacheSubscriptionPlansUseCase;
  final GetPreferredArticleTextScaleFactorUseCase _getPreferredArticleTextScaleFactorUseCase;
  final SetPreferredArticleTextScaleFactorUseCase _setPreferredArticleTextScaleFactorUseCase;
  final ShouldUseTextSizeSelectorUseCase _shouldUseTextSizeSelectorUseCase;

  final _moreFromBriefItems = <BriefEntryItem>[];
  final _otherTopicItems = <MediaItem>[];
  final _relatedContentItems = <CategoryItem>[];
  final _featuredCategories = <Category>[];

  StreamSubscription? _freeArticlesLeftWarningSubscription;
  String? _lastFreeArticlesLeftWarning;

  late Article _currentFullArticle;
  late String? _topicId;
  late String? _briefId;
  late String? _topicTitle;
  late NeatPeriodicTaskScheduler? _readingProgressTrackingScheduler;

  late bool _showTextScaleFactorSelector;
  late double _preferredTextScaleFactor;

  UpdateArticleProgressResponse? _updateArticleProgressResponse;

  UpdateArticleProgressResponse? get updateArticleProgressResponse => _updateArticleProgressResponse;
  String? get topicId => _topicId;
  String? get briefId => _briefId;
  String get topicTitle {
    if (_topicTitle != null) {
      return _topicTitle!;
    }
    Fimber.e('_topicTitle was requested and is null');
    return '';
  }

  var scrollData = MediaItemScrollData.initial();

  @override
  Future<void> close() async {
    await _readingProgressTrackingScheduler?.stop();
    await _freeArticlesLeftWarningSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize(
    Article article,
    String? briefId,
    String? topicSlug,
    String? topicId,
  ) async {
    emit(const PremiumArticleViewState.initial());

    _showTextScaleFactorSelector = await _shouldUseTextSizeSelectorUseCase();
    _preferredTextScaleFactor = await _getPreferredArticleTextScaleFactorUseCase();

    _briefId = briefId;
    _topicId = topicId;

    _currentFullArticle = article;

    _emitIdleState();

    _setupReadingProgressTracker();

    if (!_currentFullArticle.metadata.availableInSubscription) {
      await _precacheSubscriptionPlansUseCase();
    }

    if (topicSlug != null) {
      _topicTitle = (await _getTopicBySlugUseCase.call(topicSlug)).strippedTitle;
      _otherTopicItems.addAll(await _getOtherTopicEntriesUseCase(_currentFullArticle.metadata.slug, topicSlug));
    } else if (briefId != null) {
      _moreFromBriefItems.addAll(await _getOtherBriefEntriesUseCase(_currentFullArticle.metadata.slug, briefId));
    }

    _featuredCategories.addAll(await _getFeaturedCategoriesUseCase());
    _relatedContentItems.addAll(await _getRelatedContentUseCase(_currentFullArticle.metadata.slug));

    emit(const PremiumArticleViewState.initial());
    _emitIdleState();

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
  }

  void updateScrollData(double scrollOffset, double maxExtent) {
    scrollData = scrollData.copyWith(
      readArticleContentOffset: scrollOffset,
      contentHeight: maxExtent - scrollData.contentOffset,
    );
  }

  void _setupReadingProgressTracker() {
    _readingProgressTrackingScheduler = kIsTest
        ? null
        : NeatPeriodicTaskScheduler(
            interval: const Duration(seconds: 3),
            name: 'reading-progress-tracker-premium',
            timeout: const Duration(milliseconds: 1500),
            task: _trackReadingProgress,
            minCycle: const Duration(milliseconds: 1500),
          );

    _readingProgressTrackingScheduler?.start();
  }

  Future<void> _trackReadingProgress() async {
    final progress = (scrollData.progress * 100).toInt().clamp(1, 100);
    if (_currentFullArticle.metadata.availableInSubscription &&
        progress > (_updateArticleProgressResponse?.progress.contentProgress ?? 0)) {
      final updateArticleProgressResponse =
          await _trackArticleReadingProgressUseCase(_currentFullArticle.metadata, progress);
      _updateArticleProgressResponse = updateArticleProgressResponse;
    }
    return;
  }

  Future<void> setPreferredArticleTextScaleFactor(double textScaleFactor) async {
    _preferredTextScaleFactor = textScaleFactor;
    await _setPreferredArticleTextScaleFactorUseCase(_preferredTextScaleFactor);
  }

  void _emitIdleState() {
    emit(
      PremiumArticleViewState.idle(
        article: _currentFullArticle,
        moreFromBriefItems: _moreFromBriefItems,
        otherTopicItems: _otherTopicItems,
        featuredCategories: _featuredCategories,
        relatedContentItems: _relatedContentItems,
        preferredArticleTextScaleFactor: _preferredTextScaleFactor,
        showTextScaleFactorSelector: _showTextScaleFactorSelector,
      ),
    );
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
}

extension on MediaItemScrollData {
  double get progress => contentHeight > 0 ? readArticleContentOffset / contentHeight : 0.0;
}
