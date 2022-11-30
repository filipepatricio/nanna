import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/widget/explore_area_header.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
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
        Column(
          mainAxisSize: MainAxisSize.min,
          children: area.articles
              .map(
                (article) => ArticleCover.list(
                  article: article,
                  onTap: () => context.navigateToArticle(article),
                ),
              )
              .take(area.articles.length * 2 - 1)
              .toList(),
        ),
        const SizedBox(height: AppDimens.explorePageSectionBottomPadding),
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
