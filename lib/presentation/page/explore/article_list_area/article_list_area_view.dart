import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/widget/explore_area_header.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/card_divider.dart';
import 'package:flutter/material.dart';

class ArticleListAreaView extends StatelessWidget {
  const ArticleListAreaView({
    required this.area,
    Key? key,
  }) : super(key: key);

  final ExploreContentAreaArticlesList area;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.ml),
        ExploreAreaHeader(
          title: area.title,
          description: area.description,
        ),
        const SizedBox(height: AppDimens.l),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: area.articles
              .asMap()
              .entries
              .map((e) {
                final index = e.key;
                final article = e.value;
                return Column(
                  children: [
                    ArticleCover.medium(
                      article: article,
                      onTap: () => context.navigateToArticle(article),
                    ),
                    if (index != (area.articles.length - 1)) const CardDivider.cover(),
                  ],
                );
              })
              .take(area.articles.length * 2 - 1)
              .toList(),
        ),
        const SizedBox(height: AppDimens.explorePageSectionBottomPadding),
        const CardDivider.cover(),
      ],
    );
  }
}

extension on BuildContext {
  void navigateToArticle(MediaItemArticle article) {
    pushRoute(
      MediaItemPageRoute(article: article),
    );
  }
}
