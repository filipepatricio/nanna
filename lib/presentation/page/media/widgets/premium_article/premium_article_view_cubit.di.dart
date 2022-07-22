import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_other_brief_entries_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_other_topic_entries_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_related_content_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/track_article_reading_progress_use_case.di.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:better_informed_mobile/domain/categories/use_case/get_featured_categories_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/get_show_article_more_from_brief_section_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/get_show_article_related_content_section_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/get_show_more_from_topic_use_case.di.dart';
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
    this._getShowArticleMoreFromBriefSectionUseCase,
    this._getShowArticleRelatedContentSectionUseCase,
    this._getOtherTopicEntriesUseCase,
    this._getShowMoreFromTopicUseCase,
    this._getFeaturedCategoriesUseCase,
    this._getRelatedContentUseCase,
  ) : super(const PremiumArticleViewState.initial());

  final TrackActivityUseCase _trackActivityUseCase;
  final GetTopicBySlugUseCase _getTopicBySlugUseCase;
  final TrackArticleReadingProgressUseCase _trackArticleReadingProgressUseCase;
  final GetOtherBriefEntriesUseCase _getOtherBriefEntriesUseCase;
  final GetShowArticleMoreFromBriefSectionUseCase _getShowArticleMoreFromBriefSectionUseCase;
  final GetShowArticleRelatedContentSectionUseCase _getShowArticleRelatedContentSectionUseCase;
  final GetOtherTopicEntriesUseCase _getOtherTopicEntriesUseCase;
  final GetShowMoreFromTopicUseCase _getShowMoreFromTopicUseCase;
  final GetFeaturedCategoriesUseCase _getFeaturedCategoriesUseCase;
  final GetRelatedContentUseCase _getRelatedContentUseCase;

  late Article _currentFullArticle;
  late String? _topicId;
  late String? _briefId;
  late String? _topicTitle;
  late NeatPeriodicTaskScheduler? _readingProgressTrackingScheduler;

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
    return super.close();
  }

  Future<void> initialize(
    Article article,
    String? briefId,
    String? topicSlug,
    String? topicId,
  ) async {
    emit(const PremiumArticleViewState.initial());

    var showArticleMoreFromSection = false;
    var showArticleRelatedContentSection = false;
    final moreFromBriefItems = <BriefEntryItem>[];
    final otherTopicItems = <MediaItem>[];
    final relatedContentItems = <CategoryItem>[];
    final featuredCategories = <Category>[];

    _briefId = briefId;
    _topicId = topicId;

    _currentFullArticle = article;

    emit(
      PremiumArticleViewState.idle(
        article: _currentFullArticle,
        showArticleRelatedContentSection: showArticleRelatedContentSection,
        showArticleMoreFromSection: showArticleMoreFromSection,
        moreFromBriefItems: moreFromBriefItems,
        otherTopicItems: otherTopicItems,
        featuredCategories: featuredCategories,
        relatedContentItems: relatedContentItems,
      ),
    );

    _setupReadingProgressTracker();

    if (topicSlug != null) {
      showArticleMoreFromSection = await _getShowMoreFromTopicUseCase();
      if (showArticleMoreFromSection) {
        _topicTitle = (await _getTopicBySlugUseCase.call(topicSlug)).strippedTitle;
        otherTopicItems.addAll(await _getOtherTopicEntriesUseCase(_currentFullArticle.metadata.slug, topicSlug));
      }
    } else if (briefId != null) {
      showArticleMoreFromSection = await _getShowArticleMoreFromBriefSectionUseCase();
      if (showArticleMoreFromSection) {
        moreFromBriefItems.addAll(await _getOtherBriefEntriesUseCase(_currentFullArticle.metadata.slug));
      }
    }

    showArticleRelatedContentSection = await _getShowArticleRelatedContentSectionUseCase();

    if (showArticleRelatedContentSection) {
      featuredCategories.addAll(await _getFeaturedCategoriesUseCase());
      relatedContentItems.addAll(await _getRelatedContentUseCase(_currentFullArticle.metadata.slug));
    }

    emit(
      PremiumArticleViewState.idle(
        article: _currentFullArticle,
        showArticleRelatedContentSection: showArticleRelatedContentSection,
        showArticleMoreFromSection: showArticleMoreFromSection,
        moreFromBriefItems: moreFromBriefItems,
        otherTopicItems: otherTopicItems,
        featuredCategories: featuredCategories,
        relatedContentItems: relatedContentItems,
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
    _trackReadingProgress();
  }

  void _setupReadingProgressTracker() {
    _readingProgressTrackingScheduler = kIsTest
        ? null
        : NeatPeriodicTaskScheduler(
            interval: const Duration(seconds: 5),
            name: 'reading-progress-tracker',
            timeout: const Duration(seconds: 1),
            task: _trackReadingProgress,
            minCycle: const Duration(seconds: 2),
          );

    _readingProgressTrackingScheduler?.start();
  }

  Future<void> _trackReadingProgress() async {
    final progress = (scrollData.progress * 100).toInt().clamp(0, 100);
    _trackArticleReadingProgressUseCase.call(_currentFullArticle.metadata.slug, progress);
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
}

extension on MediaItemScrollData {
  double get progress => contentHeight > 0 ? readArticleContentOffset / contentHeight : 0.0;
}
