import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/relax/relax_view.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/sections/related_content/related_categories.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/sections/related_content/related_content.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';

class RelatedContentSection extends StatelessWidget {
  const RelatedContentSection({
    required this.articleId,
    required this.featuredCategories,
    required this.briefId,
    required this.relatedContentItems,
    required this.topicId,
    this.onRelatedContentItemTap,
    this.onRelatedCategoryTap,
    Key? key,
  }) : super(key: key);

  final String articleId;
  final List<Category> featuredCategories;
  final String? briefId;
  final List<CategoryItem> relatedContentItems;
  final String? topicId;
  final void Function(CategoryItem)? onRelatedContentItemTap;
  final void Function(Category)? onRelatedCategoryTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (featuredCategories.isNotEmpty || relatedContentItems.isNotEmpty) const SizedBox(height: AppDimens.l),
          if (featuredCategories.isNotEmpty)
            RelatedCategories(
              featuredCategories,
              onItemTap: onRelatedCategoryTap,
            ),
          if (relatedContentItems.isNotEmpty)
            RelatedContent(
              onItemTap: onRelatedContentItemTap,
              relatedContentItems: relatedContentItems,
              briefId: briefId,
              topicId: topicId,
            ),
          Padding(
            padding: const EdgeInsets.all(AppDimens.m),
            child: RelaxView.article(),
          ),
          SizedBox(
            height: kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom + AppDimens.s,
          ),
        ],
      ),
    );
  }
}
