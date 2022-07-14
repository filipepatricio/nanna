import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'premium_article_view_state.dt.freezed.dart';

@freezed
class PremiumArticleViewState with _$PremiumArticleViewState {
  const factory PremiumArticleViewState.initial() = _PremiumArticleViewStateInitial;

  @Implements<BuildState>()
  const factory PremiumArticleViewState.idle({
    required List<BriefEntryItem> otherBriefItems,
    required List<Category> featuredCategories,
    required bool showArticleRelatedContentSection,
    required bool showArticleMoreSection,
    required List<CategoryItem> relatedContentItems,
  }) = _PremiumArticleViewStateIdle;
}
