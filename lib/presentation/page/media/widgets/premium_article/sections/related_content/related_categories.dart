import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/pills_area/category_pill.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';

class RelatedCategories extends StatelessWidget {
  const RelatedCategories(
    this.featuredCategories, {
    required this.onItemTap,
    Key? key,
  }) : super(key: key);

  final void Function(Category)? onItemTap;
  final List<Category> featuredCategories;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
          child: Text(
            LocaleKeys.article_relatedContent_exploreMoreCategories.tr(),
            style: AppTypography.h1Medium,
          ),
        ),
        const SizedBox(height: AppDimens.m),
        SizedBox(
          height: AppDimens.explorePillHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
            itemBuilder: (context, index) => CategoryPill(
              title: featuredCategories[index].name,
              color: featuredCategories[index].color,
              onTap: () {
                onItemTap?.call(featuredCategories[index]);

                context.navigateTo(
                  CategoryPageRoute(
                    category: featuredCategories[index].asCategoryWithItems(),
                  ),
                );
              },
            ),
            separatorBuilder: (context, _) => const SizedBox(width: AppDimens.s),
            itemCount: featuredCategories.length,
          ),
        ),
        const SizedBox(height: AppDimens.s),
      ],
    );
  }
}
