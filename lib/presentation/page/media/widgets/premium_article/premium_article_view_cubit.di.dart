import 'package:better_informed_mobile/domain/article/use_case/get_other_brief_entries_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_other_topic_entries_use_case.di.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/categories/use_case/get_featured_categories_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/get_show_article_more_from_brief_section_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/get_show_article_related_content_section_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/get_show_more_from_topic_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class PremiumArticleViewCubit extends Cubit<PremiumArticleViewState> {
  PremiumArticleViewCubit(
    this._getOtherBriefEntriesUseCase,
    this._getShowArticleMoreFromBriefSectionUseCase,
    this._getShowArticleRelatedContentSectionUseCase,
    this._getOtherTopicEntriesUseCase,
    this._getShowMoreFromTopicUseCase,
    this._getFeaturedCategoriesUseCase,
  ) : super(const PremiumArticleViewState.initial());

  final GetOtherBriefEntriesUseCase _getOtherBriefEntriesUseCase;
  final GetShowArticleMoreFromBriefSectionUseCase _getShowArticleMoreFromBriefSectionUseCase;
  final GetShowArticleRelatedContentSectionUseCase _getShowArticleRelatedContentSectionUseCase;
  final GetOtherTopicEntriesUseCase _getOtherTopicEntriesUseCase;
  final GetShowMoreFromTopicUseCase _getShowMoreFromTopicUseCase;
  final GetFeaturedCategoriesUseCase _getFeaturedCategoriesUseCase;

  Future<void> initialize(
    String slug,
    String? briefId,
    String? topicSlug,
  ) async {
    emit(const PremiumArticleViewState.initial());

    final otherBriefItems = <BriefEntryItem>[];
    var showArticleMoreSection = false;
    final featuredCategories = <Category>[];

    if (topicSlug != null || briefId != null) {
      final showArticleMoreFromBriefSection = await _getShowArticleMoreFromBriefSectionUseCase();
      final showArticleMoreFromTopic = await _getShowMoreFromTopicUseCase();

      if (showArticleMoreFromBriefSection && briefId != null) {
        showArticleMoreSection = true;
        otherBriefItems.addAll(await _getOtherBriefEntriesUseCase(slug));
      } else if (showArticleMoreFromTopic && topicSlug != null) {
        showArticleMoreSection = true;
        final mediaItemList = await _getOtherTopicEntriesUseCase(slug, topicSlug);
        final briefEntryArticleItemList =
            mediaItemList.map((article) => BriefEntryItemArticle(article: article)).toList();
        otherBriefItems.addAll(briefEntryArticleItemList);
      }
    }

    final showArticleRelatedContentSection = await _getShowArticleRelatedContentSectionUseCase();

    if (showArticleRelatedContentSection) {
      featuredCategories.addAll(await _getFeaturedCategoriesUseCase());
    }

    emit(
      PremiumArticleViewState.idle(
        otherBriefItems: otherBriefItems,
        featuredCategories: featuredCategories,
        showArticleRelatedContentSection: showArticleRelatedContentSection,
        showArticleMoreSection: showArticleMoreSection,
      ),
    );
  }
}
