import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_area_referred.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_area_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/widget/explore_area_header.dart';
import 'package:better_informed_mobile/presentation/page/explore/widget/explore_area_item_carousel_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/card_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArticleAreaView extends HookWidget {
  ArticleAreaView({
    required this.area,
    required this.isHighlighted,
    Key? key,
  })  : _items = ExploreAreaItemGenerator.generate(
          area.articles,
          viewAllTitle: area.title,
        ),
        super(key: key);

  final ExploreContentAreaArticles area;
  final bool isHighlighted;
  final List<ExploreAreaItem<MediaItemArticle>> _items;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * AppDimens.exploreTopicCarouselSmallCoverWidthFactor;
    final height = width * AppDimens.exploreArticleCarouselSmallCoverAspectRatio;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.ml),
        ExploreAreaHeader(
          title: area.title,
          description: area.description,
        ),
        const SizedBox(height: AppDimens.m),
        ExploreAreaItemCarouselView<MediaItemArticle>(
          areaId: area.id,
          itemWidth: width,
          itemHeight: height,
          items: _items,
          itemBuilder: (article, index) => ArticleCover.small(
            article: article,
            onTap: () => context.navigateToArticle(article),
          ),
          onViewAllTap: () => context.navigateToSeeAll(area, isHighlighted),
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

  void navigateToSeeAll(ExploreContentAreaArticles area, bool isHighlighted) {
    pushRoute(
      ArticleSeeAllPageRoute(
        areaId: area.id,
        title: area.title,
        entries: area.articles,
        areaBackgroundColor: area.backgroundColor != null ? Color(area.backgroundColor!) : null,
        referred: isHighlighted ? ExploreAreaReferred.highlightedStream : ExploreAreaReferred.stream,
      ),
    );
  }
}
