import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/general/result_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sliver_tools/sliver_tools.dart';

const _gridColumnCount = 2;

class ResultsIdleView extends StatelessWidget {
  const ResultsIdleView({
    required this.items,
    required this.scrollController,
    this.withLoader = false,
    Key? key,
  }) : super(key: key);

  final List<ResultItem> items;
  final ScrollController scrollController;
  final bool withLoader;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverPadding(
          padding: const EdgeInsets.all(AppDimens.l),
          sliver: SliverAlignedGrid.count(
            crossAxisCount: _gridColumnCount,
            mainAxisSpacing: AppDimens.l,
            crossAxisSpacing: AppDimens.l,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return items[index].mapOrNull(
                article: (data) => ArticleCover.exploreCarousel(
                  article: data.article,
                  onTap: () => context.navigateToArticle(data.article),
                  coverColor: AppColors.mockedColors[index % AppColors.mockedColors.length],
                ),
                topic: (data) => TopicCover.exploreSmall(
                  topic: data.topicPreview,
                  onTap: () => context.navigateToTopic(data.topicPreview),
                  hasBackgroundColor: false,
                ),
              );
            },
          ),
        ),
        if (withLoader)
          const SliverPadding(
            padding: EdgeInsets.all(AppDimens.xl),
            sliver: SliverToBoxAdapter(
              child: Loader(
                color: AppColors.limeGreen,
              ),
            ),
          ),
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

  void navigateToTopic(TopicPreview topicPreview) {
    pushRoute(
      TopicPage(
        topicSlug: topicPreview.slug,
      ),
    );
  }
}
