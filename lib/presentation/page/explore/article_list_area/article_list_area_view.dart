import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/widget/explore_area_header.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';

class ArticleListAreaView extends StatelessWidget {
  const ArticleListAreaView({
    required this.area,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  final ExploreContentAreaArticlesList area;
  final SnackbarController snackbarController;

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
          isPreferred: area.isPreferred,
        ),
        const SizedBox(height: AppDimens.m),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: area.articles
                .map(
                  (article) => ArticleCover.exploreList(
                    article: article,
                    onTap: () => context.navigateToArticle(article),
                    coverColor: AppColors.mockedColors[_getColorIndex(article)],
                    snackbarController: snackbarController,
                  ),
                )
                .expand(
                  (row) => [
                    row,
                    const _Separator(),
                  ],
                )
                .take(area.articles.length * 2 - 1)
                .toList(),
          ),
        ),
        const SizedBox(height: AppDimens.explorePageSectionBottomPadding),
      ],
    );
  }

  int _getColorIndex(MediaItemArticle article) {
    return area.articles.indexOf(article) % AppColors.mockedColors.length;
  }
}

class _Separator extends StatelessWidget {
  const _Separator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppDimens.m),
      height: 1,
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
