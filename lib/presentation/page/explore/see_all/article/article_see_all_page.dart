import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_area_referred.dart';
import 'package:better_informed_mobile/presentation/page/explore/article_with_cover_area/article_list_item.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/article/article_see_all_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/article/article_see_all_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/article/article_with_background.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/see_all_load_more_indicator.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/widget/fixed_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/next_page_load_executor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArticleSeeAllPage extends HookWidget {
  final String areaId;
  final String title;
  final List<MediaItemArticle> entries;
  final ExploreAreaReferred referred;

  const ArticleSeeAllPage({
    required this.areaId,
    required this.title,
    required this.entries,
    required this.referred,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final cubit = useCubit<ArticleSeeAllPageCubit>();
    final state = useCubitBuilder<ArticleSeeAllPageCubit, ArticleSeeAllPageState>(cubit);
    final pageStorageKey = useMemoized(() => PageStorageKey(areaId));

    useEffect(
      () {
        cubit.initialize(areaId, entries);
      },
      [cubit],
    );

    final shouldListen = state.maybeMap(
      withPagination: (_) => true,
      orElse: () => false,
    );

    return Scaffold(
      appBar: FixedAppBar(scrollController: scrollController, title: title),
      body: AudioPlayerBannerWrapper(
        layout: AudioPlayerBannerLayout.column,
        child: NextPageLoadExecutor(
          enabled: shouldListen,
          onNextPageLoad: cubit.loadNextPage,
          scrollController: scrollController,
          child: TabBarListener(
            currentPage: context.routeData,
            controller: scrollController,
            child: _Body(
              title: title,
              state: state,
              scrollController: scrollController,
              pageStorageKey: pageStorageKey,
            ),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final String title;
  final ArticleSeeAllPageState state;
  final ScrollController scrollController;
  final PageStorageKey pageStorageKey;

  const _Body({
    required this.title,
    required this.state,
    required this.scrollController,
    required this.pageStorageKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state.maybeMap(
      loading: (_) => const Loader(),
      withPagination: (state) => _ArticleGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        articles: state.articles,
        scrollController: scrollController,
        withLoader: false,
      ),
      loadingMore: (state) => _ArticleGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        articles: state.articles,
        scrollController: scrollController,
        withLoader: true,
      ),
      allLoaded: (state) => _ArticleGrid(
        title: title,
        pageStorageKey: pageStorageKey,
        articles: state.articles,
        scrollController: scrollController,
        withLoader: false,
      ),
      orElse: () => const SizedBox(),
    );
  }
}

class _ArticleGrid extends StatelessWidget {
  final String title;
  final PageStorageKey pageStorageKey;
  final List<ArticleWithBackground> articles;
  final ScrollController scrollController;
  final bool withLoader;

  const _ArticleGrid({
    required this.title,
    required this.pageStorageKey,
    required this.articles,
    required this.scrollController,
    required this.withLoader,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoScrollGlow(
      child: CustomScrollView(
        controller: scrollController,
        key: pageStorageKey,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                const SizedBox(height: AppDimens.l),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                  child: InformedMarkdownBody(
                    markdown: title,
                    highlightColor: AppColors.transparent,
                    baseTextStyle: AppTypography.h1,
                  ),
                ),
                const SizedBox(height: AppDimens.l),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _GridItem(
                  article: articles[index],
                  index: index,
                ),
                childCount: articles.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: AppDimens.exploreAreaArticleSeeAllCoverHeight,
                crossAxisSpacing: AppDimens.m,
                mainAxisSpacing: AppDimens.l,
              ),
            ),
          ),
          SeeAllLoadMoreIndicator(show: withLoader),
        ],
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  final ArticleWithBackground article;
  final int index;

  const _GridItem({
    required this.article,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return article.map(
          image: (data) => ArticleListItem(
            article: article.article,
            themeColor: AppColors.background,
            height: AppDimens.exploreAreaArticleSeeAllCoverHeight,
          ),
          color: (data) => ArticleListItem(
            article: article.article,
            themeColor: AppColors.background,
            cardColor: AppColors.mockedColors[data.colorIndex % AppColors.mockedColors.length],
            height: AppDimens.exploreAreaArticleSeeAllCoverHeight,
          ),
        );
      },
    );
  }
}
