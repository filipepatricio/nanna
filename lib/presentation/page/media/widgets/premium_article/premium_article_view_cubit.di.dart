import 'package:better_informed_mobile/domain/article/use_case/get_other_brief_entries_use_case.di.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/categories/use_case/get_featured_categories_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/get_show_article_more_from_brief_section_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/get_show_article_related_content_section_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class PremiumArticleViewCubit extends Cubit<PremiumArticleViewState> {
  PremiumArticleViewCubit(
    this._getOtherBriefEntriesUseCase,
    this._getShowArticleMoreFromBriefSectionUseCase,
    this._getShowArticleRelatedContentSectionUseCase,
    this._getFeaturedCategoriesUseCase,
  ) : super(const PremiumArticleViewState.initial());

  final GetOtherBriefEntriesUseCase _getOtherBriefEntriesUseCase;
  final GetShowArticleMoreFromBriefSectionUseCase _getShowArticleMoreFromBriefSectionUseCase;
  final GetShowArticleRelatedContentSectionUseCase _getShowArticleRelatedContentSectionUseCase;
  final GetFeaturedCategoriesUseCase _getFeaturedCategoriesUseCase;

  Future<void> initialize(String slug, String? briefId) async {
    emit(const PremiumArticleViewState.initial());

    final otherBriefItems = <BriefEntryItem>[];
    final featuredCategories = <Category>[];

    final showArticleMoreFromBriefSection = await _getShowArticleMoreFromBriefSectionUseCase();
    final showArticleRelatedContentSection = await _getShowArticleRelatedContentSectionUseCase();

    if (showArticleMoreFromBriefSection && briefId != null) {
      otherBriefItems.addAll(await _getOtherBriefEntriesUseCase(slug));
    }

    if (showArticleRelatedContentSection) {
      featuredCategories.addAll(await _getFeaturedCategoriesUseCase());
    }

    emit(
      PremiumArticleViewState.idle(
        otherBriefItems: otherBriefItems,
        featuredCategories: featuredCategories,
        showArticleRelatedContentSection: showArticleRelatedContentSection,
        showArticleMoreFromBriefSection: showArticleMoreFromBriefSection,
      ),
    );
  }
}
