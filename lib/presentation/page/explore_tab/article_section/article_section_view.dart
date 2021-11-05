import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_section.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/article_with_cover_section/article_list_item.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/see_all_button.dart';
import 'package:flutter/material.dart';

class ArticleSectionView extends StatelessWidget {
  final ExploreContentSectionArticles section;

  const ArticleSectionView({
    required this.section,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.xc),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Row(
            children: [
              Expanded(
                child: Hero(
                  // TODO change to some ID or UUID if available
                  tag: HeroTag.exploreArticleTitle(section.title.hashCode),
                  child: InformedMarkdownBody(
                    markdown: section.title,
                    baseTextStyle: AppTypography.h1,
                    highlightColor: AppColors.transparent,
                    maxLines: 2,
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.s),
              SeeAllButton(
                onTap: () => AutoRouter.of(context).push(
                  ArticleSeeAllPageRoute(
                    title: section.title,
                    entries: section.articles,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.l),
        SizedBox(
          height: listItemHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            itemBuilder: (context, index) => ArticleListItem(
              entry: section.articles[index],
              themeColor: AppColors.background,
              cardColor: AppColors.mockedColors[index % AppColors.mockedColors.length],
            ),
            separatorBuilder: (context, index) => const SizedBox(width: AppDimens.s),
            itemCount: section.articles.length,
          ),
        ),
        const SizedBox(height: AppDimens.xxl),
      ],
    );
  }
}
