import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'premium_article_view_state.dt.freezed.dart';

@Freezed(toJson: false)
class PremiumArticleViewState with _$PremiumArticleViewState {
  const factory PremiumArticleViewState.initial() = _PremiumArticleViewStateInitial;

  @Implements<BuildState>()
  const factory PremiumArticleViewState.idle({
    required Article article,
    required List<BriefEntryItem> moreFromBriefItems,
    required List<MediaItem> otherTopicItems,
    required List<Category> featuredCategories,
    required List<CategoryItem> relatedContentItems,
    required double preferredArticleTextScaleFactor,
    required bool showTextScaleFactorSelector,
  }) = _PremiumArticleViewStateIdle;

  const factory PremiumArticleViewState.freeArticlesWarning({
    required String message,
  }) = _PremiumArticleViewStateFreeArticlesWarning;
}
