import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_area_referred.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/article_with_cover_area/article_list_item.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_area_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/widget/explore_area_header.dart';
import 'package:better_informed_mobile/presentation/page/explore/widget/explore_area_item_carousel_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _cellWidthFactor = 0.4;
const _aspectRatio = 1.52;

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
    final width = MediaQuery.of(context).size.width * _cellWidthFactor;
    final height = width * _aspectRatio;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.l),
        ExploreAreaHeader(
          title: area.title,
          description: area.description,
        ),
        const SizedBox(height: AppDimens.m),
        ExploreAreaItemCarouselView<MediaItemArticle>(
          areaId: area.id,
          itemBuilder: (article, index) => ArticleListItem(
            article: article,
            themeColor: AppColors.background,
            cardColor: AppColors.mockedColors[index % AppColors.mockedColors.length],
          ),
          items: _items,
          itemWidth: width,
          itemHeight: height,
          onViewAllTap: () => _navigateToSeeAll(context),
        ),
        const SizedBox(height: AppDimens.l),
      ],
    );
  }

  void _navigateToSeeAll(BuildContext context) => AutoRouter.of(context).push(
        ArticleSeeAllPageRoute(
          areaId: area.id,
          title: area.title,
          entries: area.articles,
          referred: isHighlighted ? ExploreAreaReferred.highlightedStream : ExploreAreaReferred.stream,
        ),
      );
}
