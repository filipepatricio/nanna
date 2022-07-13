import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/pills_area/explore_pill.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';

class RelatedCategories extends StatelessWidget {
  const RelatedCategories(this.featuredCategories, {Key? key}) : super(key: key);

  final List<Category> featuredCategories;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Text(
            LocaleKeys.article_relatedContent_exploreMoreCategories.tr(),
            style: AppTypography.h1ExtraBold,
          ),
        ),
        const SizedBox(height: AppDimens.m),
        SizedBox(
          height: AppDimens.explorePillHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            itemBuilder: (context, index) => ExplorePill(
              title: featuredCategories[index].name,
              icon: featuredCategories[index].icon,
              index: index,
              onTap: () => context.navigateTo(
                CategoryPageRoute(
                  category: featuredCategories[index],
                ),
              ),
            ),
            separatorBuilder: (context, _) => const SizedBox(width: AppDimens.m),
            itemCount: featuredCategories.length,
          ),
        ),
        const SizedBox(height: AppDimens.s),
      ],
    );
  }
}